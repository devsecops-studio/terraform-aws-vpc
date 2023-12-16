locals {
  others_public_subnets            = [for suffix in local.cidr_configs.others_public : format("%s.%s", var.cidr_prefix, suffix)]
  len_others_public_subnets        = length(local.others_public_subnets)
  create_others_public_subnets     = local.create_vpc && (var.create_others_public_subnets || local.nat_gateway_count > 0) && local.len_others_public_subnets > 0
  create_others_public_route_table = local.create_others_public_subnets && var.create_others_public_subnet_route_table
}

resource "aws_subnet" "others_public" {
  count = local.create_others_public_subnets && (!var.one_nat_gateway_per_az || local.len_others_public_subnets >= length(local.azs)) ? local.len_others_public_subnets : 0

  availability_zone                              = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id                           = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null
  cidr_block                                     = var.ipv6_native ? null : element(concat(local.others_public_subnets, [""]), count.index)
  enable_resource_name_dns_a_record_on_launch    = !var.ipv6_native && var.others_public_subnet_enable_resource_name_dns_a_record_on_launch
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 && var.enable_resource_name_dns_aaaa_record_on_launch
  private_dns_hostname_type_on_launch            = !var.ipv6_native ? var.private_dns_hostname_type_on_launch : "resource-name"

  assign_ipv6_address_on_creation = var.enable_ipv6 && var.ipv6_native ? true : false
  enable_dns64                    = var.enable_ipv6 && var.enable_dns64
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(aws_vpc.this[0].ipv6_cidr_block, 8, local.ipv6_prefixes.others_public[count.index]) : null
  ipv6_native                     = var.enable_ipv6 && var.ipv6_native

  vpc_id = local.vpc_id

  tags = merge(
    {
      Name = format("${var.name}-${var.others_public_subnet_suffix}-%s", element(local.azs, count.index))
    },
    var.tags,
    var.others_public_subnet_tags,
    lookup(var.others_public_subnet_tags_per_az, element(local.azs, count.index), {})
  )
}

resource "aws_route_table" "others_public" {
  count = local.create_others_public_route_table ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    { "Name" = "${var.name}-${var.others_public_subnet_suffix}" },
    var.tags,
    var.others_public_route_table_tags,
  )
}

resource "aws_route_table_association" "others_public" {
  count = local.create_others_public_subnets ? local.len_others_public_subnets : 0

  subnet_id = element(aws_subnet.others_public[*].id, count.index)
  route_table_id = element(
    coalescelist(aws_route_table.others_public[*].id, aws_route_table.public[*].id),
    local.create_others_public_route_table ? var.single_nat_gateway ? 0 : count.index : count.index,
  )
}

resource "aws_route" "others_public_internet_gateway" {
  count = local.create_others_public_route_table && var.create_igw ? 1 : 0

  route_table_id         = aws_route_table.others_public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

module "others_public_network_acl" {
  source = "./modules/network-acl"

  create = local.create_others_public_subnets && var.others_public_dedicated_network_acl ? true : false

  vpc_id             = local.vpc_id
  subnet_ids         = aws_subnet.others_public[*].id
  inbound_acl_rules  = var.others_public_inbound_acl_rules
  outbound_acl_rules = var.others_public_outbound_acl_rules

  tags = merge(
    { "Name" = "${var.name}-${var.others_public_subnet_suffix}" },
    var.tags,
    var.others_public_acl_tags,
  )
}
