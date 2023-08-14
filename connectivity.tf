locals {
  connectivity_subnets        = [for suffix in local.cidr_configs.connectivity : format("%s.%s", var.cidr_prefix, suffix)]
  len_connectivity_subnets    = length(local.connectivity_subnets)
  create_connectivity_subnets = local.create_vpc && var.create_connectivity_subnets && local.len_connectivity_subnets > 0
  create_connectivity_route_table = local.create_connectivity_subnets && var.create_connectivity_subnet_route_table
}

resource "aws_subnet" "connectivity" {
  count = local.create_connectivity_subnets ? local.len_connectivity_subnets : 0

  availability_zone                              = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id                           = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null
  cidr_block                                     = element(concat(local.connectivity_subnets, [""]), count.index)
  enable_resource_name_dns_a_record_on_launch    = var.connectivity_subnet_enable_resource_name_dns_a_record_on_launch
  private_dns_hostname_type_on_launch            = var.private_dns_hostname_type_on_launch
  vpc_id = local.vpc_id

  tags = merge(
    {
      Name = try(
        var.connectivity_subnet_names[count.index],
        format("${var.name}-${var.connectivity_subnet_suffix}-%s", element(local.azs, count.index))
      )
    },
    var.tags,
    var.connectivity_subnet_tags,
    lookup(var.connectivity_subnet_tags_per_az, element(local.azs, count.index), {})
  )
}

resource "aws_route_table" "connectivity" {
  count = local.create_connectivity_route_table ? local.nat_gateway_count > 0 ? local.nat_gateway_count : 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = var.single_nat_gateway ? "${var.name}-${var.connectivity_subnet_suffix}" : format(
        "${var.name}-${var.connectivity_subnet_suffix}-%s",
        element(local.azs, count.index),
      )
    },
    var.tags,
    var.connectivity_route_table_tags,
  )
}

resource "aws_route_table_association" "connectivity" {
  count = local.create_connectivity_subnets ? local.len_connectivity_subnets : 0

  subnet_id = element(aws_subnet.connectivity[*].id, count.index)
  route_table_id = element(
    coalescelist(aws_route_table.connectivity[*].id, aws_route_table.private[*].id),
    local.create_connectivity_route_table ? var.single_nat_gateway ? 0 : count.index : count.index,
  )
}

resource "aws_route" "connectivity_nat_gateway" {
  count = local.create_connectivity_route_table && var.create_connectivity_nat_gateway_route && var.enable_nat_gateway ? var.single_nat_gateway ? 1 : local.nat_gateway_count : 0

  route_table_id         = element(aws_route_table.connectivity[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
}

module "connectivity_network_acl" {
  source = "./modules/network-acl"

  create = local.create_connectivity_subnets && var.connectivity_dedicated_network_acl ? true : false

  vpc_id             = local.vpc_id
  subnet_ids         = aws_subnet.connectivity[*].id
  inbound_acl_rules  = var.connectivity_inbound_acl_rules
  outbound_acl_rules = var.connectivity_outbound_acl_rules

  tags = merge(
    { "Name" = "${var.name}-${var.connectivity_subnet_suffix}" },
    var.tags,
    var.connectivity_acl_tags,
  )
}
