module "vpc" {
  source = "../../"

  name        = "complete"
  cidr_prefix = "10.11"

  secondary_cidr_blocks = ["10.101.0.0/16"]

  # IPv6
  one_nat_gateway_per_az = true

  # LB
  lb_internal_dedicated_network_acl     = true
  create_lb_internal_subnet_route_table = true

  lb_external_dedicated_network_acl     = true
  create_lb_external_subnet_route_table = true

  # EC2
  ec2_public_dedicated_network_acl     = true
  create_ec2_public_subnet_route_table = true

  ec2_private_dedicated_network_acl     = true
  create_ec2_private_subnet_route_table = true

  # Others
  others_public_dedicated_network_acl     = true
  create_others_public_subnet_route_table = true

  others_private_dedicated_network_acl     = true
  create_others_private_subnet_route_table = true

  # ECS
  ecs_dedicated_network_acl     = true
  create_ecs_subnet_route_table = true

  # EKS
  eks_dedicated_network_acl     = true
  create_eks_subnet_route_table = true

  # Cache
  cache_dedicated_network_acl     = true
  create_cache_subnet_route_table = true

  # DB
  db_dedicated_network_acl     = true
  create_db_subnet_route_table = true
}
