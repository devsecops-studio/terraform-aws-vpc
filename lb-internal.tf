locals {
  lb_internal_subnets        = [for suffix in local.cidr_configs.lb_internal : format("%s.%s", var.cidr_prefix, suffix)]
  len_lb_internal_subnets    = max(length(local.lb_internal_subnets), length(var.lb_internal_subnet_ipv6_prefixes))
  create_lb_internal_subnets = local.create_vpc && local.len_lb_internal_subnets > 0
  create_lb_internal_route_table = local.create_lb_internal_subnets && var.create_lb_internal_subnet_route_table
}

resource "aws_subnet" "lb_internal" {
  count = local.create_lb_internal_subnets ? local.len_lb_internal_subnets : 0

  assign_ipv6_address_on_creation                = var.enable_ipv6 && var.lb_internal_subnet_ipv6_native ? true : var.lb_internal_subnet_assign_ipv6_address_on_creation
  availability_zone                              = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id                           = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null
  cidr_block                                     = var.lb_internal_subnet_ipv6_native ? null : element(concat(local.lb_internal_subnets, [""]), count.index)
  enable_dns64                                   = var.enable_ipv6 && var.lb_internal_subnet_enable_dns64
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 && var.lb_internal_subnet_enable_resource_name_dns_aaaa_record_on_launch
  enable_resource_name_dns_a_record_on_launch    = !var.lb_internal_subnet_ipv6_native && var.lb_internal_subnet_enable_resource_name_dns_a_record_on_launch
  ipv6_cidr_block                                = var.enable_ipv6 && length(var.lb_internal_subnet_ipv6_prefixes) > 0 ? cidrsubnet(aws_vpc.this[0].ipv6_cidr_block, 8, var.lb_internal_subnet_ipv6_prefixes[count.index]) : null
  ipv6_native                                    = var.enable_ipv6 && var.lb_internal_subnet_ipv6_native
  private_dns_hostname_type_on_launch            = var.private_dns_hostname_type_on_launch
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
  count = local.create_lb_internal_route_table ? local.nat_gateway_count : 0

  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = var.single_nat_gateway ? "${var.name}-${var.lb_internal_subnet_suffix}" : format(
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
    coalescelist(aws_route_table.lb_internal[*].id, aws_route_table.private[*].id),
    local.create_lb_internal_route_table ? var.single_nat_gateway ? 0 : count.index : count.index,
  )
}

resource "aws_route" "lb_internal_nat_gateway" {
  count = local.create_lb_internal_route_table && var.enable_nat_gateway ? var.single_nat_gateway ? 1 : local.nat_gateway_count : 0

  route_table_id         = element(aws_route_table.lb_internal[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
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
