locals {
  others_private_subnets         = [for suffix in local.cidr_configs.others_private : format("%s.%s", var.cidr_prefix, suffix)]
  len_others_private_subnets     = max(length(local.others_private_subnets), length(var.others_private_subnet_ipv6_prefixes))
  create_others_private_subnets  = local.create_vpc && local.len_others_private_subnets > 0
  create_others_private_route_table = local.create_others_private_subnets && var.create_others_private_subnet_route_table
}

resource "aws_subnet" "others_private" {
  count = local.create_others_private_subnets && (!var.one_nat_gateway_per_az || local.len_others_private_subnets >= length(local.azs)) ? local.len_others_private_subnets : 0

  assign_ipv6_address_on_creation                = var.others_private_subnet_assign_ipv6_address_on_creation
  availability_zone                              = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id                           = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null
  cidr_block                                     = element(concat(local.others_private_subnets, [""]), count.index)
  enable_dns64                                   = var.enable_ipv6 && var.others_private_subnet_enable_dns64
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 && var.others_private_subnet_enable_resource_name_dns_aaaa_record_on_launch
  enable_resource_name_dns_a_record_on_launch    = var.others_private_subnet_enable_resource_name_dns_a_record_on_launch
  ipv6_cidr_block                                = var.enable_ipv6 && length(var.others_private_subnet_ipv6_prefixes) > 0 ? cidrsubnet(aws_vpc.this[0].ipv6_cidr_block, 8, var.others_private_subnet_ipv6_prefixes[count.index]) : null
  private_dns_hostname_type_on_launch            = var.private_dns_hostname_type_on_launch
  vpc_id                                         = local.vpc_id

  tags = merge(
    {
      Name = format("${var.name}-${var.others_private_subnet_suffix}-%s", element(local.azs, count.index))
    },
    var.tags,
    var.others_private_subnet_tags,
    lookup(var.others_private_subnet_tags_per_az, element(local.azs, count.index), {})
  )
}

resource "aws_route_table" "others_private" {
  count = local.create_others_private_route_table ? local.nat_gateway_count : 0

  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = var.single_nat_gateway ? "${var.name}-${var.others_private_subnet_suffix}" : format(
        "${var.name}-${var.others_private_subnet_suffix}-%s",
        element(local.azs, count.index),
      )
    },
    var.tags,
    var.others_private_route_table_tags,
  )
}

resource "aws_route_table_association" "others_private" {
  count = local.create_others_private_subnets ? local.len_others_private_subnets : 0

  subnet_id      = element(aws_subnet.others_private[*].id, count.index)
  route_table_id = element(
    coalescelist(aws_route_table.others_private[*].id, aws_route_table.private[*].id),
    local.create_ec2_private_route_table ? var.single_nat_gateway ? 0 : count.index : count.index,
  )
}

resource "aws_route" "others_private_nat_gateway" {
  count = local.create_others_private_route_table && var.enable_nat_gateway ? var.single_nat_gateway ? 1 : local.nat_gateway_count : 0

  route_table_id         = element(aws_route_table.others_private[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
}

module "others_private_network_acl" {
  source = "./modules/network-acl"

  create = local.create_others_private_subnets && var.others_private_dedicated_network_acl ? true : false

  vpc_id             = local.vpc_id
  subnet_ids         = aws_subnet.others_private[*].id
  inbound_acl_rules  = var.others_private_inbound_acl_rules
  outbound_acl_rules = var.others_private_outbound_acl_rules

  tags = merge(
    { "Name" = "${var.name}-${var.others_private_subnet_suffix}" },
    var.tags,
    var.others_private_acl_tags,
  )
}
