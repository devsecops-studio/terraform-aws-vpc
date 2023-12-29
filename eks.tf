locals {
  eks_subnets            = [for suffix in local.cidr_configs.eks : format("%s.%s", var.cidr_prefix, suffix)]
  len_eks_subnets        = length(local.eks_subnets)
  create_eks_subnets     = local.create_vpc && var.create_eks_subnets && local.len_eks_subnets > 0
  create_eks_route_table = local.create_eks_subnets && var.create_eks_subnet_route_table
}

resource "aws_subnet" "eks" {
  count = local.create_eks_subnets && (!var.one_nat_gateway_per_az || local.len_eks_subnets >= length(local.azs)) ? local.len_eks_subnets : 0

  availability_zone                              = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  availability_zone_id                           = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) == 0 ? element(local.azs, count.index) : null
  cidr_block                                     = var.ipv6_native ? null : element(concat(local.eks_subnets, [""]), count.index)
  enable_resource_name_dns_a_record_on_launch    = !var.ipv6_native && var.eks_subnet_enable_resource_name_dns_a_record_on_launch
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 && var.enable_resource_name_dns_aaaa_record_on_launch
  map_public_ip_on_launch                        = !var.ipv6_native ? false : null
  private_dns_hostname_type_on_launch            = !var.ipv6_native ? var.private_dns_hostname_type_on_launch : "resource-name"

  assign_ipv6_address_on_creation = var.enable_ipv6 ? true : false
  enable_dns64                    = var.enable_ipv6 && var.enable_dns64
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(aws_vpc.this[0].ipv6_cidr_block, 8, local.ipv6_prefixes.eks[count.index]) : null
  ipv6_native                     = var.enable_ipv6 && var.ipv6_native

  vpc_id = local.vpc_id

  tags = merge(
    {
      Name = format("${var.name}-${var.eks_subnet_suffix}-%s", element(local.azs, count.index))
    },
    var.tags,
    var.eks_subnet_tags,
    lookup(var.eks_subnet_tags_per_az, element(local.azs, count.index), {})
  )
}

resource "aws_route_table" "eks" {
  count = local.create_eks_route_table ? var.ipv6_native ? 1 : local.nat_gateway_count : 0

  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = var.single_nat_gateway || var.ipv6_native ? "${var.name}-${var.eks_subnet_suffix}" : format(
        "${var.name}-${var.eks_subnet_suffix}-%s",
        element(local.azs, count.index),
      )
    },
    var.tags,
    var.eks_route_table_tags,
  )
}

resource "aws_route_table_association" "eks" {
  count = local.create_eks_subnets ? local.len_eks_subnets : 0

  subnet_id = element(aws_subnet.eks[*].id, count.index)
  route_table_id = element(
    coalescelist(aws_route_table.eks[*].id, aws_route_table.private[*].id),
    local.create_eks_subnets ? var.single_nat_gateway ? 0 : count.index : count.index,
  )
}

resource "aws_route" "eks_nat_gateway" {
  count = local.create_eks_route_table && !var.ipv6_native && var.enable_nat_gateway ? var.single_nat_gateway ? 1 : local.nat_gateway_count : 0

  route_table_id         = element(aws_route_table.eks[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "eks_egress_internet_gateway" {
  count = local.create_eks_route_table && var.ipv6_native ? var.single_nat_gateway ? 1 : local.nat_gateway_count : 0

  route_table_id              = element(aws_route_table.eks[*].id, count.index)
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = element(aws_egress_only_internet_gateway.this[*].id, 0)

  timeouts {
    create = "5m"
  }
}

module "eks_network_acl" {
  source = "./modules/network-acl"

  create = local.create_eks_subnets && var.eks_dedicated_network_acl ? true : false

  vpc_id             = local.vpc_id
  subnet_ids         = aws_subnet.eks[*].id
  inbound_acl_rules  = var.eks_inbound_acl_rules
  outbound_acl_rules = var.eks_outbound_acl_rules

  tags = merge(
    { "Name" = "${var.name}-${var.eks_subnet_suffix}" },
    var.tags,
    var.eks_acl_tags,
  )
}
