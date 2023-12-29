locals {
  lb_internal_subnets            = [for suffix in local.cidr_configs.lb_internal : format("%s.%s", var.cidr_prefix, suffix)]
  len_lb_internal_subnets        = length(local.lb_internal_subnets)
  create_lb_internal_subnets     = local.create_vpc && var.create_lb_internal_subnets && local.len_lb_internal_subnets > 0
  create_lb_internal_route_table = local.create_lb_internal_subnets && var.create_lb_internal_subnet_route_table
}

resource "aws_subnet" "lb_internal" {
  count = local.create_lb_internal_subnets ? local.len_lb_internal_subnets : 0

  availability_zone                              = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id                           = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null
  cidr_block                                     = var.ipv6_native ? null : element(concat(local.lb_internal_subnets, [""]), count.index)
  enable_resource_name_dns_a_record_on_launch    = var.lb_internal_subnet_enable_resource_name_dns_a_record_on_launch
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 && var.enable_resource_name_dns_aaaa_record_on_launch
  private_dns_hostname_type_on_launch            = !var.ipv6_native ? var.private_dns_hostname_type_on_launch : "resource-name"

  assign_ipv6_address_on_creation = var.enable_ipv6 ? true : false
  enable_dns64                    = var.enable_ipv6 && var.enable_dns64
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(aws_vpc.this[0].ipv6_cidr_block, 8, local.ipv6_prefixes.lb_internal[count.index]) : null
  ipv6_native                     = var.enable_ipv6 && var.ipv6_native

  vpc_id = local.vpc_id

  tags = merge(
    {
      Name = try(
        var.lb_internal_subnet_names[count.index],
        format("${var.name}-${var.lb_internal_subnet_suffix}-%s", element(local.azs, count.index))
      )
    },
    var.tags,
    var.lb_internal_subnet_tags,
    lookup(var.lb_internal_subnet_tags_per_az, element(local.azs, count.index), {})
  )
}

resource "aws_route_table" "lb_internal" {
  count = local.create_lb_internal_route_table ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = var.single_nat_gateway || local.nat_gateway_count == 0 || var.ipv6_native ? "${var.name}-${var.lb_internal_subnet_suffix}" : format(
        "${var.name}-${var.lb_internal_subnet_suffix}-%s",
        element(local.azs, count.index),
      )
    },
    var.tags,
    var.lb_internal_route_table_tags,
  )
}

resource "aws_route_table_association" "lb_internal" {
  count = local.create_lb_internal_subnets ? local.len_lb_internal_subnets : 0

  subnet_id = element(aws_subnet.lb_internal[*].id, count.index)
  route_table_id = element(
    coalescelist(aws_route_table.lb_internal[*].id, aws_default_route_table.default[*].id),
    0,
  )
}

module "lb_internal_network_acl" {
  source = "./modules/network-acl"

  create = local.create_lb_internal_subnets && var.lb_internal_dedicated_network_acl ? true : false

  vpc_id             = local.vpc_id
  subnet_ids         = aws_subnet.lb_internal[*].id
  inbound_acl_rules  = var.lb_internal_inbound_acl_rules
  outbound_acl_rules = var.lb_internal_outbound_acl_rules

  tags = merge(
    { "Name" = "${var.name}-${var.lb_internal_subnet_suffix}" },
    var.tags,
    var.lb_internal_acl_tags,
  )
}
