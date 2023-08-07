locals {
  public_route_table_ids      = aws_route_table.public[*].id
  private_route_table_ids     = aws_route_table.private[*].id
  ec2_public_route_table_ids  = try(aws_route_table.ec2_public[*].id, null)
  ec2_private_route_table_ids = try(aws_route_table.ec2_private[*].id, null)
  ecs_route_table_ids         = try(aws_route_table.ecs[*].id, null)
}

# ################################################################################
# # VPC
# ################################################################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.this[0].id, null)
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(aws_vpc.this[0].arn, null)
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.this[0].cidr_block, null)
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = try(aws_vpc.this[0].default_security_group_id, null)
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = try(aws_vpc.this[0].default_network_acl_id, null)
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = try(aws_vpc.this[0].default_route_table_id, null)
}

# output "vpc_instance_tenancy" {
#   description = "Tenancy of instances spin up within VPC"
#   value       = try(aws_vpc.this[0].instance_tenancy, null)
# }

# output "vpc_enable_dns_hostnames" {
#   description = "Whether or not the VPC has DNS hostname support"
#   value       = try(aws_vpc.this[0].enable_dns_hostnames, null)
# }

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = try(aws_vpc.this[0].main_route_table_id, null)
}

output "public_route_table_ids" {
  description = "Public route tables associated with this VPC"
  value       = try(aws_route_table.public[*].id, null)
}

output "private_route_table_ids" {
  description = "Private route tables associated with this VPC"
  value       = try(aws_route_table.private[*].id, null)
}

output "vpc_secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks of the VPC"
  value       = compact(aws_vpc_ipv4_cidr_block_association.this[*].cidr_block)
}

output "vpc_owner_id" {
  description = "The ID of the AWS account that owns the VPC"
  value       = try(aws_vpc.this[0].owner_id, null)
}

# ################################################################################
# # DHCP Options Set
# ################################################################################

# output "dhcp_options_id" {
#   description = "The ID of the DHCP options"
#   value       = try(aws_vpc_dhcp_options.this[0].id, null)
# }

# ################################################################################
# # Internet Gateway
# ################################################################################

# output "igw_id" {
#   description = "The ID of the Internet Gateway"
#   value       = try(aws_internet_gateway.this[0].id, null)
# }

# output "igw_arn" {
#   description = "The ARN of the Internet Gateway"
#   value       = try(aws_internet_gateway.this[0].arn, null)
# }

# ################################################################################
# # EC2 Publiс Subnets
# ################################################################################

output "ec2_public_subnets" {
  description = "List of IDs of EC2 public subnets"
  value       = aws_subnet.ec2_public[*].id
}

output "ec2_public_subnet_arns" {
  description = "List of ARNs of EC2 public subnets"
  value       = aws_subnet.ec2_public[*].arn
}

output "ec2_public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of EC2 public subnets"
  value       = compact(aws_subnet.ec2_public[*].cidr_block)
}

output "ec2_public_route_table_ids" {
  description = "List of IDs of EC2 public route tables"
  value       = local.ec2_public_route_table_ids
}

# output "ec2_public_network_acl_id" {
#   description = "ID of the EC2 public network ACL"
#   value       = try(aws_network_acl.ec2_public[0].id, null)
# }

# output "ec2_public_network_acl_arn" {
#   description = "ARN of the EC2 public network ACL"
#   value       = try(aws_network_acl.ec2_public[0].arn, null)
# }

# ################################################################################
# # EC2 Private Subnets
# ################################################################################

output "ec2_private_subnets" {
  description = "List of IDs of EC2 private subnets"
  value       = aws_subnet.ec2_private[*].id
}

output "ec2_private_subnet_arns" {
  description = "List of ARNs of EC2 private subnets"
  value       = aws_subnet.ec2_private[*].arn
}

output "ec2_private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of EC2 private subnets"
  value       = compact(aws_subnet.ec2_private[*].cidr_block)
}

output "ec2_private_route_table_ids" {
  description = "List of IDs of EC2 private route tables"
  value       = local.ec2_private_route_table_ids
}

# output "ec2_private_network_acl_id" {
#   description = "ID of the EC2 private network ACL"
#   value       = try(aws_network_acl.ec2_private[0].id, null)
# }

# output "ec2_private_network_acl_arn" {
#   description = "ARN of the EC2 private network ACL"
#   value       = try(aws_network_acl.ec2_private[0].arn, null)
# }

# ################################################################################
# # ECS Subnets
# ################################################################################

output "ecs_subnets" {
  description = "List of IDs of ECS subnets"
  value       = aws_subnet.ecs[*].id
}

output "ecs_subnet_arns" {
  description = "List of ARNs of ECS subnets"
  value       = aws_subnet.ecs[*].arn
}

output "ecs_subnets_cidr_blocks" {
  description = "List of cidr_blocks of ECS subnets"
  value       = compact(aws_subnet.ecs[*].cidr_block)
}

output "ecs_route_table_ids" {
  description = "List of IDs of ECS route tables"
  value       = local.ecs_route_table_ids
}

# output "ecs_network_acl_id" {
#   description = "ID of the ECS network ACL"
#   value       = try(aws_network_acl.ecs[0].id, null)
# }

# output "ecs_network_acl_arn" {
#   description = "ARN of the EC2 private network ACL"
#   value       = try(aws_network_acl.ecs[0].arn, null)
# }

# ################################################################################
# # Load Balancer Public Subnets
# ################################################################################

output "lb_external_subnets" {
  description = "List of IDs of Load Balancer public subnets"
  value       = aws_subnet.lb_external[*].id
}

output "lb_external_subnet_arns" {
  description = "List of ARNs of Load Balancer public subnets"
  value       = aws_subnet.lb_external[*].arn
}

output "lb_external_subnets_cidr_blocks" {
  description = "List of cidr_blocks of Load Balancer public subnets"
  value       = compact(aws_subnet.lb_external[*].cidr_block)
}

output "lb_external_route_table_ids" {
  description = "List of IDs of Load Balancer public route tables"
  value       = try(aws_route_table.lb_external[*].id, null)
}

# ################################################################################
# # Load Balancer Private Subnets
# ################################################################################

output "lb_internal_subnets" {
  description = "List of IDs of Load Balancer private subnets"
  value       = aws_subnet.lb_internal[*].id
}

output "lb_internal_subnet_arns" {
  description = "List of ARNs of Load Balancer private subnets"
  value       = aws_subnet.lb_internal[*].arn
}

output "lb_internal_subnets_cidr_blocks" {
  description = "List of cidr_blocks of Load Balancer private subnets"
  value       = compact(aws_subnet.lb_internal[*].cidr_block)
}

output "lb_internal_route_table_ids" {
  description = "List of IDs of Load Balancer private route tables"
  value       = try(aws_route_table.lb_internal[*].id, null)
}

# ################################################################################
# # Other Private Subnets
# ################################################################################

output "others_private_subnets" {
  description = "List of IDs of other private subnets"
  value       = aws_subnet.others_private[*].id
}

output "others_private_subnet_arns" {
  description = "List of ARNs of other private subnets"
  value       = aws_subnet.others_private[*].arn
}

output "others_private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of other private subnets"
  value       = compact(aws_subnet.others_private[*].cidr_block)
}

output "others_private_route_table_ids" {
  description = "List of IDs of others private route tables"
  value       = try(aws_route_table.others_private[*].id, null)
}

# ################################################################################
# # Database Subnets
# ################################################################################

# output "database_subnets" {
#   description = "List of IDs of database subnets"
#   value       = aws_subnet.database[*].id
# }

# output "database_subnet_arns" {
#   description = "List of ARNs of database subnets"
#   value       = aws_subnet.database[*].arn
# }

# output "database_subnets_cidr_blocks" {
#   description = "List of cidr_blocks of database subnets"
#   value       = compact(aws_subnet.database[*].cidr_block)
# }

# output "database_subnets_ipv6_cidr_blocks" {
#   description = "List of IPv6 cidr_blocks of database subnets in an IPv6 enabled VPC"
#   value       = compact(aws_subnet.database[*].ipv6_cidr_block)
# }

# output "database_subnet_group" {
#   description = "ID of database subnet group"
#   value       = try(aws_db_subnet_group.database[0].id, null)
# }

# output "database_subnet_group_name" {
#   description = "Name of database subnet group"
#   value       = try(aws_db_subnet_group.database[0].name, null)
# }

# output "database_route_table_ids" {
#   description = "List of IDs of database route tables"
#   value       = try(coalescelist(aws_route_table.database[*].id, local.private_route_table_ids), [])
# }

# output "database_internet_gateway_route_id" {
#   description = "ID of the database internet gateway route"
#   value       = try(aws_route.database_internet_gateway[0].id, null)
# }

# output "database_nat_gateway_route_ids" {
#   description = "List of IDs of the database nat gateway route"
#   value       = aws_route.database_nat_gateway[*].id
# }

# output "database_ipv6_egress_route_id" {
#   description = "ID of the database IPv6 egress route"
#   value       = try(aws_route.database_ipv6_egress[0].id, null)
# }

# output "database_route_table_association_ids" {
#   description = "List of IDs of the database route table association"
#   value       = aws_route_table_association.database[*].id
# }

# output "database_network_acl_id" {
#   description = "ID of the database network ACL"
#   value       = try(aws_network_acl.database[0].id, null)
# }

# output "database_network_acl_arn" {
#   description = "ARN of the database network ACL"
#   value       = try(aws_network_acl.database[0].arn, null)
# }

# ################################################################################
# # Elasticache Subnets
# ################################################################################

# output "elasticache_subnets" {
#   description = "List of IDs of elasticache subnets"
#   value       = aws_subnet.elasticache[*].id
# }

# output "elasticache_subnet_arns" {
#   description = "List of ARNs of elasticache subnets"
#   value       = aws_subnet.elasticache[*].arn
# }

# output "elasticache_subnets_cidr_blocks" {
#   description = "List of cidr_blocks of elasticache subnets"
#   value       = compact(aws_subnet.elasticache[*].cidr_block)
# }

# output "elasticache_subnets_ipv6_cidr_blocks" {
#   description = "List of IPv6 cidr_blocks of elasticache subnets in an IPv6 enabled VPC"
#   value       = compact(aws_subnet.elasticache[*].ipv6_cidr_block)
# }

# output "elasticache_subnet_group" {
#   description = "ID of elasticache subnet group"
#   value       = try(aws_elasticache_subnet_group.elasticache[0].id, null)
# }

# output "elasticache_subnet_group_name" {
#   description = "Name of elasticache subnet group"
#   value       = try(aws_elasticache_subnet_group.elasticache[0].name, null)
# }

# output "elasticache_route_table_ids" {
#   description = "List of IDs of elasticache route tables"
#   value       = try(coalescelist(aws_route_table.elasticache[*].id, local.private_route_table_ids), [])
# }

# output "elasticache_route_table_association_ids" {
#   description = "List of IDs of the elasticache route table association"
#   value       = aws_route_table_association.elasticache[*].id
# }

# output "elasticache_network_acl_id" {
#   description = "ID of the elasticache network ACL"
#   value       = try(aws_network_acl.elasticache[0].id, null)
# }

# output "elasticache_network_acl_arn" {
#   description = "ARN of the elasticache network ACL"
#   value       = try(aws_network_acl.elasticache[0].arn, null)
# }

# ################################################################################
# # NAT Gateway
# ################################################################################

output "nat_ids" {
  description = "List of allocation ID of Elastic IPs created for AWS NAT Gateway"
  value       = aws_eip.nat[*].id
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = var.reuse_nat_ips ? var.external_nat_ips : aws_eip.nat[*].public_ip
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.this[*].id
}

# ################################################################################
# # Egress Only Gateway
# ################################################################################

# output "egress_only_internet_gateway_id" {
#   description = "The ID of the egress only Internet Gateway"
#   value       = try(aws_egress_only_internet_gateway.this[0].id, null)
# }

# ################################################################################
# # Customer Gateway
# ################################################################################

# output "cgw_ids" {
#   description = "List of IDs of Customer Gateway"
#   value       = [for k, v in aws_customer_gateway.this : v.id]
# }

# output "cgw_arns" {
#   description = "List of ARNs of Customer Gateway"
#   value       = [for k, v in aws_customer_gateway.this : v.arn]
# }

# output "this_customer_gateway" {
#   description = "Map of Customer Gateway attributes"
#   value       = aws_customer_gateway.this
# }

# ################################################################################
# # VPN Gateway
# ################################################################################

# output "vgw_id" {
#   description = "The ID of the VPN Gateway"
#   value       = try(aws_vpn_gateway.this[0].id, aws_vpn_gateway_attachment.this[0].vpn_gateway_id, null)
# }

# output "vgw_arn" {
#   description = "The ARN of the VPN Gateway"
#   value       = try(aws_vpn_gateway.this[0].arn, null)
# }

# ################################################################################
# # Default VPC
# ################################################################################

# output "default_vpc_id" {
#   description = "The ID of the Default VPC"
#   value       = try(aws_default_vpc.this[0].id, null)
# }

# output "default_vpc_arn" {
#   description = "The ARN of the Default VPC"
#   value       = try(aws_default_vpc.this[0].arn, null)
# }

# output "default_vpc_cidr_block" {
#   description = "The CIDR block of the Default VPC"
#   value       = try(aws_default_vpc.this[0].cidr_block, null)
# }

# output "default_vpc_default_security_group_id" {
#   description = "The ID of the security group created by default on Default VPC creation"
#   value       = try(aws_default_vpc.this[0].default_security_group_id, null)
# }

# output "default_vpc_default_network_acl_id" {
#   description = "The ID of the default network ACL of the Default VPC"
#   value       = try(aws_default_vpc.this[0].default_network_acl_id, null)
# }

# output "default_vpc_default_route_table_id" {
#   description = "The ID of the default route table of the Default VPC"
#   value       = try(aws_default_vpc.this[0].default_route_table_id, null)
# }

# output "default_vpc_instance_tenancy" {
#   description = "Tenancy of instances spin up within Default VPC"
#   value       = try(aws_default_vpc.this[0].instance_tenancy, null)
# }

# output "default_vpc_enable_dns_support" {
#   description = "Whether or not the Default VPC has DNS support"
#   value       = try(aws_default_vpc.this[0].enable_dns_support, null)
# }

# output "default_vpc_enable_dns_hostnames" {
#   description = "Whether or not the Default VPC has DNS hostname support"
#   value       = try(aws_default_vpc.this[0].enable_dns_hostnames, null)
# }

# output "default_vpc_main_route_table_id" {
#   description = "The ID of the main route table associated with the Default VPC"
#   value       = try(aws_default_vpc.this[0].main_route_table_id, null)
# }

# ################################################################################
# # VPC Flow Log
# ################################################################################

# output "vpc_flow_log_id" {
#   description = "The ID of the Flow Log resource"
#   value       = try(aws_flow_log.this[0].id, null)
# }

# output "vpc_flow_log_destination_arn" {
#   description = "The ARN of the destination for VPC Flow Logs"
#   value       = local.flow_log_destination_arn
# }

# output "vpc_flow_log_destination_type" {
#   description = "The type of the destination for VPC Flow Logs"
#   value       = var.flow_log_destination_type
# }

# output "vpc_flow_log_cloudwatch_iam_role_arn" {
#   description = "The ARN of the IAM role used when pushing logs to Cloudwatch log group"
#   value       = local.flow_log_iam_role_arn
# }

# ################################################################################
# # Static values (arguments)
# ################################################################################

output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = local.azs
}

output "name" {
  description = "The name of the VPC specified as argument to this module"
  value       = var.name
}
