locals {
  lb_external_subnets            = [for suffix in local.cidr_configs.lb_external : format("%s.%s", var.cidr_prefix, suffix)]
  len_lb_external_subnets        = length(local.lb_external_subnets)
  create_lb_external_subnets     = local.create_vpc && var.create_lb_external_subnets && local.len_lb_external_subnets > 0
  create_lb_external_route_table = local.create_lb_external_subnets && var.create_lb_external_subnet_route_table
}

resource "aws_subnet" "lb_external" {
  count = local.create_lb_external_subnets && (!var.one_nat_gateway_per_az || local.len_lb_external_subnets >= length(local.azs)) ? local.len_lb_external_subnets : 0

  availability_zone                              = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id                           = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null
  cidr_block                                     = var.ipv6_native ? null : element(concat(local.lb_external_subnets, [""]), count.index)
  enable_resource_name_dns_a_record_on_launch    = !var.ipv6_native && var.lb_external_subnet_enable_resource_name_dns_a_record_on_launch
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 && var.enable_resource_name_dns_aaaa_record_on_launch
  private_dns_hostname_type_on_launch            = !var.ipv6_native ? var.private_dns_hostname_type_on_launch : "resource-name"

  assign_ipv6_address_on_creation = var.enable_ipv6 && var.ipv6_native ? true : false
  enable_dns64                    = var.enable_ipv6 && var.enable_dns64
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(aws_vpc.this[0].ipv6_cidr_block, 8, local.ipv6_prefixes.lb_external[count.index]) : null
  ipv6_native                     = var.enable_ipv6 && var.ipv6_native

  vpc_id = local.vpc_id

  tags = merge(
    {
      Name = format("${var.name}-${var.lb_external_subnet_suffix}-%s", element(local.azs, count.index))
    },
    var.tags,
    var.lb_external_subnet_tags,
    lookup(var.lb_external_subnet_tags_per_az, element(local.azs, count.index), {})
  )
}

resource "aws_route_table" "lb_external" {
  count = local.create_lb_external_route_table ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = "${var.name}-${var.lb_external_subnet_suffix}"
    },
    var.tags,
    var.lb_external_route_table_tags,
  )
}

resource "aws_route_table_association" "lb_external" {
  count = local.create_lb_external_subnets ? local.len_lb_external_subnets : 0

  subnet_id = element(aws_subnet.lb_external[*].id, count.index)
  route_table_id = element(
    coalescelist(aws_route_table.lb_external[*].id, aws_route_table.public[*].id),
    local.create_lb_external_route_table ? var.single_nat_gateway ? 0 : count.index : count.index,
  )
}

resource "aws_route" "lb_external_internet_gateway" {
  count = local.create_lb_external_route_table && var.create_igw ? 1 : 0

  route_table_id         = aws_route_table.lb_external[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

module "lb_external_network_acl" {
  source = "./modules/network-acl"

  create = local.create_lb_external_subnets && var.lb_external_dedicated_network_acl ? true : false

  vpc_id             = local.vpc_id
  subnet_ids         = aws_subnet.lb_external[*].id
  inbound_acl_rules  = var.lb_external_inbound_acl_rules
  outbound_acl_rules = var.lb_external_outbound_acl_rules

  tags = merge(
    { "Name" = "${var.name}-${var.lb_external_subnet_suffix}" },
    var.tags,
    var.lb_external_acl_tags,
  )
}
