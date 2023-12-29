locals {
  spare_subnet                    = [for suffix in local.cidr_configs.spare : format("%s.%s", var.cidr_prefix, suffix)]
  len_spare_subnet                = length(local.spare_subnet)
  create_spare_subnet             = local.create_vpc && var.create_spare_subnet && local.len_spare_subnet > 0
  create_spare_subnet_route_table = local.create_spare_subnet && var.create_spare_subnet_route_table
  enable_ipv6_native_spare_subnet = var.enable_ipv6 && (var.ipv6_native || var.spare_subnet_ipv6_native)
}

resource "aws_subnet" "spare_subnet" {
  count = local.create_spare_subnet && (!var.one_nat_gateway_per_az || local.len_spare_subnet >= length(local.azs)) ? local.len_spare_subnet : 0

  availability_zone                              = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id                           = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null
  cidr_block                                     = local.enable_ipv6_native_spare_subnet ? null : element(concat(local.spare_subnet, [""]), count.index)
  enable_resource_name_dns_a_record_on_launch    = !local.enable_ipv6_native_spare_subnet && var.spare_subnet_enable_resource_name_dns_a_record_on_launch
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 && var.enable_resource_name_dns_aaaa_record_on_launch
  map_public_ip_on_launch                        = !local.enable_ipv6_native_spare_subnet ? var.spare_subnet_map_public_ip_on_launch : null
  private_dns_hostname_type_on_launch            = !local.enable_ipv6_native_spare_subnet ? var.private_dns_hostname_type_on_launch : "resource-name"

  assign_ipv6_address_on_creation = var.enable_ipv6 ? true : false
  enable_dns64                    = var.enable_ipv6 && var.enable_dns64
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(aws_vpc.this[0].ipv6_cidr_block, 8, local.ipv6_prefixes.spare[count.index]) : null
  ipv6_native                     = local.enable_ipv6_native_spare_subnet

  vpc_id = local.vpc_id

  tags = merge(
    {
      Name = format("${var.name}-${var.spare_subnet_suffix}-%s", element(local.azs, count.index))
    },
    var.tags,
    var.spare_subnet_tags,
    lookup(var.spare_subnet_tags_per_az, element(local.azs, count.index), {})
  )
}

resource "aws_route_table" "spare_subnet" {
  count = local.create_spare_subnet_route_table ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    { "Name" = "${var.name}-${var.spare_subnet_suffix}" },
    var.tags,
    var.spare_subnet_route_table_tags,
  )
}

resource "aws_route_table_association" "spare_subnet" {
  count = local.create_spare_subnet ? local.len_spare_subnet : 0

  subnet_id = element(aws_subnet.spare_subnet[*].id, count.index)
  route_table_id = element(
    coalescelist(aws_route_table.spare_subnet[*].id, aws_default_route_table.default[*].id),
    local.create_spare_subnet_route_table ? var.single_nat_gateway ? 0 : count.index : count.index,
  )
}

resource "aws_route" "spare_subnet_internet_gateway" {
  count = local.create_spare_subnet_route_table && !var.create_spare_subnet_nat_gateway_route && var.create_igw ? 1 : 0

  route_table_id         = aws_route_table.spare_subnet[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "spare_subnet_nat_gateway" {
  count = local.create_spare_subnet_route_table && var.create_spare_subnet_nat_gateway_route && var.enable_nat_gateway ? var.single_nat_gateway ? 1 : local.len_spare_subnet : 0

  route_table_id         = element(aws_route_table.spare_subnet[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "spare_subnet_ipv6_internet_gateway" {
  count = local.create_spare_subnet_route_table && var.create_igw && var.enable_ipv6 && !var.create_spare_subnet_egress_internet_gateway_route ? 1 : 0

  route_table_id              = aws_route_table.spare_subnet[0].id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "spare_subnet_nat64" {
  count = local.create_spare_subnet_route_table && var.enable_ipv6 && var.enable_nat_gateway ? var.single_nat_gateway ? 1 : local.nat_gateway_count : 0

  route_table_id              = aws_route_table.spare_subnet[0].id
  destination_ipv6_cidr_block = "64:ff9b::/96"
  nat_gateway_id              = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "spare_subnet_egress_internet_gateway" {
  count = local.create_spare_subnet_route_table && var.enable_ipv6 && var.create_spare_subnet_egress_internet_gateway_route ? 1 : 0

  route_table_id              = aws_route_table.spare_subnet[0].id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = element(aws_egress_only_internet_gateway.this[*].id, 0)

  timeouts {
    create = "5m"
  }
}

module "spare_subnet_network_acl" {
  source = "./modules/network-acl"

  create = local.create_spare_subnet && var.spare_subnet_dedicated_network_acl ? true : false

  vpc_id             = local.vpc_id
  subnet_ids         = aws_subnet.spare_subnet[*].id
  inbound_acl_rules  = var.spare_subnet_inbound_acl_rules
  outbound_acl_rules = var.spare_subnet_outbound_acl_rules

  tags = merge(
    { "Name" = "${var.name}-${var.spare_subnet_suffix}" },
    var.tags,
    var.spare_subnet_acl_tags,
  )
}
