locals {
  cache_subnets            = [for suffix in local.cidr_configs.cache : format("%s.%s", var.cidr_prefix, suffix)]
  len_cache_subnets        = length(local.cache_subnets)
  create_cache_subnets     = local.create_vpc && var.create_cache_subnets && local.len_cache_subnets > 0
  create_cache_route_table = local.create_cache_subnets && var.create_cache_subnet_route_table
}

resource "aws_subnet" "cache" {
  count = local.create_cache_subnets ? local.len_cache_subnets : 0

  availability_zone                              = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id                           = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null
  cidr_block                                     = var.ipv6_native ? null : element(concat(local.cache_subnets, [""]), count.index)
  enable_resource_name_dns_a_record_on_launch    = !var.ipv6_native && var.cache_subnet_enable_resource_name_dns_a_record_on_launch
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 && var.enable_resource_name_dns_aaaa_record_on_launch
  private_dns_hostname_type_on_launch            = !var.ipv6_native ? var.private_dns_hostname_type_on_launch : "resource-name"

  assign_ipv6_address_on_creation = var.enable_ipv6 ? true : false
  enable_dns64                    = var.enable_ipv6 && var.enable_dns64
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(aws_vpc.this[0].ipv6_cidr_block, 8, local.ipv6_prefixes.cache[count.index]) : null
  ipv6_native                     = var.enable_ipv6 && var.ipv6_native

  vpc_id = local.vpc_id

  tags = merge(
    {
      Name = try(
        var.cache_subnet_names[count.index],
        format("${var.name}-${var.cache_subnet_suffix}-%s", element(local.azs, count.index))
      )
    },
    var.tags,
    var.cache_subnet_tags,
  )
}

resource "aws_elasticache_subnet_group" "cache" {
  count = local.create_cache_subnets && var.create_cache_subnet_group ? 1 : 0

  name        = coalesce(var.cache_subnet_group_name, var.name)
  description = "ElastiCache subnet group for ${var.name}"
  subnet_ids  = aws_subnet.cache[*].id

  tags = merge(
    { "Name" = coalesce(var.cache_subnet_group_name, var.name) },
    var.tags,
    var.cache_subnet_group_tags,
  )
}

resource "aws_route_table" "cache" {
  count = local.create_cache_route_table ? var.single_nat_gateway || var.create_cache_internet_gateway_route || !var.create_cache_nat_gateway_route ? 1 : local.nat_gateway_count : 0

  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = var.single_nat_gateway || var.create_cache_internet_gateway_route || !var.create_cache_nat_gateway_route ? "${var.name}-${var.cache_subnet_suffix}" : format(
        "${var.name}-${var.cache_subnet_suffix}-%s",
        element(local.azs, count.index),
      )
    },
    var.tags,
    var.route_table_tags,
    var.cache_route_table_tags,
  )
}

resource "aws_route_table_association" "cache_default" {
  count = local.create_cache_subnets && !local.create_cache_route_table && !var.create_cache_internet_gateway_route && !var.create_cache_nat_gateway_route ? local.len_cache_subnets : 0

  subnet_id = element(aws_subnet.cache[*].id, count.index)
  route_table_id = element(
    coalescelist(aws_route_table.cache[*].id, aws_default_route_table.default[*].id),
    var.create_cache_subnet_route_table ? var.single_nat_gateway || var.create_cache_internet_gateway_route || !var.create_cache_nat_gateway_route ? 0 : count.index : count.index,
  )
}

resource "aws_route_table_association" "cache_private" {
  count = !local.create_cache_route_table && !var.create_cache_internet_gateway_route && var.create_cache_nat_gateway_route ? local.len_cache_subnets : 0

  subnet_id = element(aws_subnet.cache[*].id, count.index)
  route_table_id = element(
    coalescelist(aws_route_table.cache[*].id, aws_route_table.private[*].id),
    var.create_cache_subnet_route_table ? var.single_nat_gateway || var.create_cache_internet_gateway_route || !var.create_cache_nat_gateway_route ? 0 : count.index : count.index,
  )
}

resource "aws_route_table_association" "cache_public" {
  count = !local.create_cache_route_table && var.create_cache_internet_gateway_route && !var.create_cache_nat_gateway_route ? local.len_cache_subnets : 0

  subnet_id = element(aws_subnet.cache[*].id, count.index)
  route_table_id = element(
    coalescelist(aws_route_table.cache[*].id, aws_route_table.public[*].id),
    var.create_cache_subnet_route_table ? var.single_nat_gateway || var.create_cache_internet_gateway_route || !var.create_cache_nat_gateway_route ? 0 : count.index : count.index,
  )
}

resource "aws_route_table_association" "cache" {
  count = local.create_cache_route_table ? local.len_cache_subnets : 0

  subnet_id = element(aws_subnet.cache[*].id, count.index)
  route_table_id = element(
    coalescelist(aws_route_table.cache[*].id, aws_route_table.private[*].id),
    var.create_cache_subnet_route_table ? var.single_nat_gateway || var.create_cache_internet_gateway_route || !var.create_cache_nat_gateway_route ? 0 : count.index : count.index,
  )
}

resource "aws_route" "cache_internet_gateway" {
  count = local.create_cache_route_table && !var.ipv6_native && var.create_igw && var.create_cache_internet_gateway_route && !var.create_cache_nat_gateway_route ? 1 : 0

  route_table_id         = aws_route_table.cache[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "cache_egress_internet_gateway" {
  count = local.create_cache_route_table && var.ipv6_native && var.create_cache_egress_internet_gateway_route ? 1 : 0

  route_table_id              = aws_route_table.cache[0].id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = element(aws_egress_only_internet_gateway.this[*].id, 0)

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "cache_nat_gateway" {
  count = local.create_cache_route_table && !var.create_cache_internet_gateway_route && var.create_cache_nat_gateway_route && var.enable_nat_gateway ? var.single_nat_gateway ? 1 : local.len_cache_subnets : 0

  route_table_id         = element(aws_route_table.cache[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
}

module "cache_network_acl" {
  source = "./modules/network-acl"

  create = local.create_cache_subnets && var.cache_dedicated_network_acl ? true : false

  vpc_id             = local.vpc_id
  subnet_ids         = aws_subnet.cache[*].id
  inbound_acl_rules  = var.cache_inbound_acl_rules
  outbound_acl_rules = var.cache_outbound_acl_rules

  tags = merge(
    { "Name" = "${var.name}-${var.cache_subnet_suffix}" },
    var.tags,
    var.cache_acl_tags,
  )
}
