locals {
  db_subnets            = [for suffix in local.cidr_configs.db : format("%s.%s", var.cidr_prefix, suffix)]
  len_db_subnets        = length(local.db_subnets)
  create_db_subnets     = local.create_vpc && var.create_db_subnets && local.len_db_subnets > 0
  create_db_route_table = local.create_db_subnets && var.create_db_subnet_route_table
}

resource "aws_subnet" "db" {
  count = local.create_db_subnets ? local.len_db_subnets : 0

  availability_zone                              = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id                           = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null
  cidr_block                                     = var.ipv6_native ? null : element(concat(local.db_subnets, [""]), count.index)
  enable_resource_name_dns_a_record_on_launch    = !var.ipv6_native && var.db_subnet_enable_resource_name_dns_a_record_on_launch
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 && var.enable_resource_name_dns_aaaa_record_on_launch
  private_dns_hostname_type_on_launch            = !var.ipv6_native ? var.private_dns_hostname_type_on_launch : "resource-name"

  assign_ipv6_address_on_creation = var.enable_ipv6 && var.ipv6_native ? true : false
  enable_dns64                    = var.enable_ipv6 && var.enable_dns64
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(aws_vpc.this[0].ipv6_cidr_block, 8, local.ipv6_prefixes.db[count.index]) : null
  ipv6_native                     = var.enable_ipv6 && var.ipv6_native

  vpc_id = local.vpc_id

  tags = merge(
    {
      Name = try(
        var.db_subnet_names[count.index],
        format("${var.name}-${var.db_subnet_suffix}-%s", element(local.azs, count.index), )
      )
    },
    var.tags,
    var.db_subnet_tags,
  )
}

resource "aws_db_subnet_group" "db" {
  count = local.create_db_subnets && !var.ipv6_native && var.create_db_subnet_group ? 1 : 0

  name        = lower(coalesce(var.db_subnet_group_name, var.name))
  description = "Database subnet group for ${var.name}"
  subnet_ids  = aws_subnet.db[*].id

  tags = merge(
    {
      "Name" = lower(coalesce(var.db_subnet_group_name, var.name))
    },
    var.tags,
    var.db_subnet_group_tags,
  )
}

resource "aws_route_table" "db" {
  count = local.create_db_route_table ? var.single_nat_gateway || var.create_db_internet_gateway_route || var.create_db_egress_internet_gateway_route || !var.create_db_nat_gateway_route ? 1 : local.nat_gateway_count : 0

  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = var.single_nat_gateway || var.create_db_internet_gateway_route || !var.create_db_nat_gateway_route ? "${var.name}-${var.db_subnet_suffix}" : format(
        "${var.name}-${var.db_subnet_suffix}-%s",
        element(local.azs, count.index),
      )
    },
    var.tags,
    var.db_route_table_tags,
  )
}

resource "aws_route_table_association" "db_default" {
  count = local.create_db_subnets && !local.create_db_route_table && !var.create_db_internet_gateway_route && !var.create_db_nat_gateway_route ? local.len_db_subnets : 0

  subnet_id = element(aws_subnet.db[*].id, count.index)
  route_table_id = element(
    coalescelist(aws_route_table.db[*].id, aws_default_route_table.default[*].id),
    var.create_db_subnet_route_table ? var.single_nat_gateway || var.create_db_internet_gateway_route || !var.create_db_nat_gateway_route ? 0 : count.index : count.index,
  )
}

resource "aws_route_table_association" "db_private" {
  count = !local.create_db_route_table && !var.create_db_internet_gateway_route && var.create_db_nat_gateway_route ? local.len_db_subnets : 0

  subnet_id = element(aws_subnet.db[*].id, count.index)
  route_table_id = element(
    coalescelist(aws_route_table.db[*].id, aws_route_table.private[*].id),
    var.create_db_subnet_route_table ? var.single_nat_gateway || var.create_db_internet_gateway_route || !var.create_db_nat_gateway_route ? 0 : count.index : count.index,
  )
}

resource "aws_route_table_association" "db_public" {
  count = !local.create_db_route_table && var.create_db_internet_gateway_route && !var.create_db_nat_gateway_route ? local.len_db_subnets : 0

  subnet_id = element(aws_subnet.db[*].id, count.index)
  route_table_id = element(
    coalescelist(aws_route_table.db[*].id, aws_route_table.public[*].id),
    var.create_db_subnet_route_table ? var.single_nat_gateway || var.create_db_internet_gateway_route || !var.create_db_nat_gateway_route ? 0 : count.index : count.index,
  )
}

resource "aws_route_table_association" "db" {
  count = local.create_db_route_table ? local.len_db_subnets : 0

  subnet_id = element(aws_subnet.db[*].id, count.index)
  route_table_id = element(
    coalescelist(aws_route_table.db[*].id, aws_route_table.private[*].id),
    var.create_db_subnet_route_table ? var.single_nat_gateway || var.create_db_internet_gateway_route || !var.create_db_nat_gateway_route ? 0 : count.index : count.index,
  )
}

resource "aws_route" "db_internet_gateway" {
  count = local.create_db_route_table && var.create_igw && var.create_db_internet_gateway_route && !var.create_db_nat_gateway_route ? 1 : 0

  route_table_id         = aws_route_table.db[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "db_egress_internet_gateway" {
  count = local.create_db_route_table && var.ipv6_native && var.create_db_egress_internet_gateway_route ? 1 : 0

  route_table_id              = aws_route_table.db[0].id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = element(aws_egress_only_internet_gateway.this[*].id, 0)

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "db_nat_gateway" {
  count = local.create_db_route_table && !var.ipv6_native && !var.create_db_internet_gateway_route && var.create_db_nat_gateway_route && var.enable_nat_gateway ? var.single_nat_gateway ? 1 : local.len_db_subnets : 0

  route_table_id         = element(aws_route_table.db[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
}

module "db_network_acl" {
  source = "./modules/network-acl"

  create = local.create_db_subnets && var.db_dedicated_network_acl ? true : false

  vpc_id             = local.vpc_id
  subnet_ids         = aws_subnet.db[*].id
  inbound_acl_rules  = var.db_inbound_acl_rules
  outbound_acl_rules = var.db_outbound_acl_rules

  tags = merge(
    { "Name" = "${var.name}-${var.db_subnet_suffix}" },
    var.tags,
    var.db_acl_tags,
  )
}
