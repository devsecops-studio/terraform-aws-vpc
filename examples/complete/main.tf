module "vpc" {
  source = "../../"

  name        = "complete"
  cidr_prefix = "10.11"

  secondary_cidr_blocks = ["10.101.0.0/16"]

  # IPv6
  enable_ipv6 = true

  # LB
  lb_internal_dedicated_network_acl = true
  lb_external_dedicated_network_acl = true

  # EC2
  ec2_public_dedicated_network_acl  = true
  ec2_private_dedicated_network_acl = true

  # Others
  others_public_dedicated_network_acl  = true
  others_private_dedicated_network_acl = true

  # ECS
  ecs_dedicated_network_acl = true

  # ECS
  eks_dedicated_network_acl = true

  # Cache
  cache_dedicated_network_acl = true

  # DB
  db_dedicated_network_acl = true
}
