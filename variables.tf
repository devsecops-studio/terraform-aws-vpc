################################################################################
# VPC
################################################################################
variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "cidr_prefix" {
  description = "The prefix IPv4 CIDR block for the VPC"
  type        = string
  default     = "10.0"
}

variable "secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool"
  type        = list(string)
  default     = []
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "private_dns_hostname_type_on_launch" {
  description = "The type of hostnames to assign to instances in the subnet at launch. For IPv6-only subnets, an instance DNS name must be based on the instance ID. For dual-stack and IPv4-only subnets, you can specify whether DNS names use the instance IPv4 address or the instance ID. Valid values: `ip-name`, `resource-name`. Default `ip-name`"
  type        = string
  default     = "ip-name"
}

variable "enable_network_address_usage_metrics" {
  description = "Determines whether network address usage metrics are enabled for the VPC"
  type        = bool
  default     = null
}

variable "ipv6_cidr" {
  description = "(Optional) IPv6 CIDR block to request from an IPAM Pool. Can be set explicitly or derived from IPAM using `ipv6_netmask_length`"
  type        = string
  default     = null
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# DHCP Options Set
################################################################################
variable "enable_dhcp_options" {
  description = "Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type"
  type        = bool
  default     = false
}

variable "dhcp_options_domain_name" {
  description = "Specifies DNS name for DHCP options set (requires enable_dhcp_options set to true)"
  type        = string
  default     = ""
}

variable "dhcp_options_domain_name_servers" {
  description = "Specify a list of DNS server addresses for DHCP options set, default to AWS provided (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}

variable "dhcp_options_ntp_servers" {
  description = "Specify a list of NTP servers for DHCP options set (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_name_servers" {
  description = "Specify a list of netbios servers for DHCP options set (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_node_type" {
  description = "Specify netbios node_type for DHCP options set (requires enable_dhcp_options set to true)"
  type        = string
  default     = ""
}

variable "dhcp_options_tags" {
  description = "Additional tags for the DHCP option set (requires enable_dhcp_options set to true)"
  type        = map(string)
  default     = {}
}

################################################################################
# LB External Subnets
################################################################################
variable "create_lb_external_subnets" {
  description = "Wheter or not to create LB external subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "lb_external_subnet_enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false`"
  type        = bool
  default     = false
}

variable "lb_external_subnet_suffix" {
  description = "Suffix to append to Load balancer public subnets name"
  type        = string
  default     = "lb-ext"
}

variable "create_lb_external_subnet_route_table" {
  description = "Controls if separate route table for LB external subnets should be created. Default: `false`"
  type        = bool
  default     = false
}

variable "lb_external_subnet_tags" {
  description = "Additional tags for the Load balancer public subnets"
  type        = map(string)
  default     = {}
}

variable "lb_external_subnet_tags_per_az" {
  description = "Additional tags for the Load balancer public subnets where the primary key is the AZ"
  type        = map(map(string))
  default     = {}
}

variable "lb_external_route_table_tags" {
  description = "Additional tags for the Load balancer public route tables"
  type        = map(string)
  default     = {}
}

################################################################################
# LB External Network ACLs
################################################################################
variable "lb_external_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for LB public subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "lb_external_inbound_acl_rules" {
  description = "LB public subnets inbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "lb_external_outbound_acl_rules" {
  description = "LB public subnets outbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "lb_external_acl_tags" {
  description = "Additional tags for the LB public subnets network ACL"
  type        = map(string)
  default     = {}
}

################################################################################
# LB Internal Subnets
################################################################################
variable "create_lb_internal_subnets" {
  description = "Wheter or not to create LB internal subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "lb_internal_subnet_enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false`"
  type        = bool
  default     = false
}

variable "lb_internal_subnet_names" {
  description = "Explicit values to use in the Name tag on LB private subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "lb_internal_subnet_suffix" {
  description = "Suffix to append to LB private subnets name"
  type        = string
  default     = "lb-int"
}

variable "create_lb_internal_subnet_route_table" {
  description = "Controls if separate route table for LB internal subnets should be created. Default: `false`"
  type        = bool
  default     = false
}

variable "lb_internal_subnet_tags" {
  description = "Additional tags for the LB private subnets"
  type        = map(string)
  default     = {}
}

variable "lb_internal_subnet_tags_per_az" {
  description = "Additional tags for the LB private subnets where the primary key is the AZ"
  type        = map(map(string))
  default     = {}
}

variable "lb_internal_route_table_tags" {
  description = "Additional tags for the LB private route tables"
  type        = map(string)
  default     = {}
}

################################################################################
# LB Private Network ACLs
################################################################################
variable "lb_internal_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for LB private subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "lb_internal_inbound_acl_rules" {
  description = "LB private subnets inbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "lb_internal_outbound_acl_rules" {
  description = "LB private subnets outbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "lb_internal_acl_tags" {
  description = "Additional tags for the LB private subnets network ACL"
  type        = map(string)
  default     = {}
}

################################################################################
# EC2 Public Subnets
################################################################################
variable "create_ec2_public_subnets" {
  description = "Wheter or not to create EC2 public subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "ec2_public_subnet_enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false`"
  type        = bool
  default     = false
}

variable "map_public_ip_on_ec2_launched" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is `true`"
  type        = bool
  default     = true
}

variable "ec2_public_subnet_suffix" {
  description = "Suffix to append to EC2 public subnets name"
  type        = string
  default     = "ec2-pub"
}

variable "create_ec2_public_subnet_route_table" {
  description = "Controls if separate route table for EC2 public subnets should be created. Default: `false`"
  type        = bool
  default     = false
}

variable "ec2_public_subnet_tags" {
  description = "Additional tags for the Ec2 public subnets"
  type        = map(string)
  default     = {}
}

variable "ec2_public_subnet_tags_per_az" {
  description = "Additional tags for the EC2 public subnets where the primary key is the AZ"
  type        = map(map(string))
  default     = {}
}

variable "ec2_public_route_table_tags" {
  description = "Additional tags for the EC2 public route tables"
  type        = map(string)
  default     = {}
}

################################################################################
# EC2 Public Network ACLs
################################################################################
variable "ec2_public_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for EC2 public subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "ec2_public_inbound_acl_rules" {
  description = "EC2 public subnets inbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "ec2_public_outbound_acl_rules" {
  description = "EC2 public subnets outbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "ec2_public_acl_tags" {
  description = "Additional tags for the EC2 public subnets network ACL"
  type        = map(string)
  default     = {}
}

################################################################################
# EC2 Private Subnets
################################################################################
variable "create_ec2_private_subnets" {
  description = "Wheter or not to create EC2 private subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "ec2_private_subnet_enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false`"
  type        = bool
  default     = false
}

variable "ec2_private_subnet_suffix" {
  description = "Suffix to append to EC2 private subnets name"
  type        = string
  default     = "ec2-priv"
}

variable "create_ec2_private_subnet_route_table" {
  description = "Controls if separate route table for EC2 private subnets should be created. Default: `false`"
  type        = bool
  default     = false
}

variable "ec2_private_subnet_tags" {
  description = "Additional tags for the Ec2 private subnets"
  type        = map(string)
  default     = {}
}

variable "ec2_private_subnet_tags_per_az" {
  description = "Additional tags for the EC2 subnets where the primary key is the AZ"
  type        = map(map(string))
  default     = {}
}

variable "ec2_private_route_table_tags" {
  description = "Additional tags for the EC2 private route tables"
  type        = map(string)
  default     = {}
}

################################################################################
# EC2 Private Network ACLs
################################################################################
variable "ec2_private_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for EC2 private subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "ec2_private_inbound_acl_rules" {
  description = "EC2 private subnets inbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "ec2_private_outbound_acl_rules" {
  description = "EC2 private subnets outbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "ec2_private_acl_tags" {
  description = "Additional tags for the EC2 private subnets network ACL"
  type        = map(string)
  default     = {}
}

################################################################################
# Others Public Subnets
################################################################################
variable "create_others_public_subnets" {
  description = "Wheter or not to create others public subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "others_public_subnet_enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false`"
  type        = bool
  default     = false
}

variable "others_public_subnet_suffix" {
  description = "Suffix to append to others public subnets name"
  type        = string
  default     = "other-pub"
}

variable "create_others_public_subnet_route_table" {
  description = "Controls if separate route table for others public subnets should be created. Default: `false`"
  type        = bool
  default     = false
}

variable "others_public_subnet_tags" {
  description = "Additional tags for others public subnets"
  type        = map(string)
  default     = {}
}

variable "others_public_subnet_tags_per_az" {
  description = "Additional tags for others public subnets where the primary key is the AZ"
  type        = map(map(string))
  default     = {}
}

variable "others_public_route_table_tags" {
  description = "Additional tags for others public route tables"
  type        = map(string)
  default     = {}
}

################################################################################
# Others Public Network ACLs
################################################################################
variable "others_public_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for others public subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "others_public_inbound_acl_rules" {
  description = "others public subnets inbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "others_public_outbound_acl_rules" {
  description = "others public subnets outbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "others_public_acl_tags" {
  description = "Additional tags for others public subnets network ACL"
  type        = map(string)
  default     = {}
}

################################################################################
# Others Private Subnets
################################################################################
variable "create_others_private_subnets" {
  description = "Wheter or not to create others private subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "others_private_subnet_enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false`"
  type        = bool
  default     = false
}

variable "others_private_subnet_suffix" {
  description = "Suffix to append to Load balancer public subnets name"
  type        = string
  default     = "others-priv"
}

variable "create_others_private_subnet_route_table" {
  description = "Controls if separate route table for others private subnets should be created. Default: `false`"
  type        = bool
  default     = false
}

variable "others_private_subnet_tags" {
  description = "Additional tags for others private public subnets"
  type        = map(string)
  default     = {}
}

variable "others_private_subnet_tags_per_az" {
  description = "Additional tags for others private subnets where the primary key is the AZ"
  type        = map(map(string))
  default     = {}
}

variable "others_private_route_table_tags" {
  description = "Additional tags for others private route tables"
  type        = map(string)
  default     = {}
}

################################################################################
# Others Private Network ACLs
################################################################################
variable "others_private_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for LB public subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "others_private_inbound_acl_rules" {
  description = "LB public subnets inbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "others_private_outbound_acl_rules" {
  description = "LB public subnets outbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "others_private_acl_tags" {
  description = "Additional tags for the LB public subnets network ACL"
  type        = map(string)
  default     = {}
}

################################################################################
# ECS Subnets
################################################################################
variable "create_ecs_subnets" {
  description = "Wheter or not to create ECS subnets. Default: `false`"
  type        = bool
  default     = false
}

variable "ecs_subnet_enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false`"
  type        = bool
  default     = false
}

variable "ecs_subnet_suffix" {
  description = "Suffix to append to ECS subnets name"
  type        = string
  default     = "ecs"
}

variable "create_ecs_subnet_route_table" {
  description = "Controls if separate route table for ECS subnets should be created. Default: `false`"
  type        = bool
  default     = false
}

variable "ecs_subnet_tags" {
  description = "Additional tags for the ECS subnets"
  type        = map(string)
  default     = {}
}

variable "ecs_subnet_tags_per_az" {
  description = "Additional tags for the ECS where the primary key is the AZ"
  type        = map(map(string))
  default     = {}
}

variable "ecs_route_table_tags" {
  description = "Additional tags for the ECS route tables"
  type        = map(string)
  default     = {}
}

################################################################################
# ECS Network ACLs
################################################################################
variable "ecs_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for ECS subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "ecs_inbound_acl_rules" {
  description = "ECS subnets inbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "ecs_outbound_acl_rules" {
  description = "ECS subnets outbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "ecs_acl_tags" {
  description = "Additional tags for the ECS subnets network ACL"
  type        = map(string)
  default     = {}
}

################################################################################
# Database Subnets
################################################################################
variable "create_db_subnets" {
  description = "Wheter or not to create database subnets. Default: `false`"
  type        = bool
  default     = false
}

variable "db_subnet_enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false`"
  type        = bool
  default     = false
}

variable "db_subnet_names" {
  description = "Explicit values to use in the Name tag on database subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "db_subnet_suffix" {
  description = "Suffix to append to database subnets name"
  type        = string
  default     = "db"
}

variable "create_db_subnet_route_table" {
  description = "Controls if separate route table for database should be created"
  type        = bool
  default     = false
}

variable "create_db_internet_gateway_route" {
  description = "Controls if an internet gateway route for public database access should be created"
  type        = bool
  default     = false
}

variable "create_db_nat_gateway_route" {
  description = "Controls if a nat gateway route should be created to give internet access to the database subnets"
  type        = bool
  default     = false
}

variable "db_route_table_tags" {
  description = "Additional tags for the database route tables"
  type        = map(string)
  default     = {}
}

variable "db_subnet_tags" {
  description = "Additional tags for the database subnets"
  type        = map(string)
  default     = {}
}

variable "create_db_subnet_group" {
  description = "Controls if database subnet group should be created (n.b. database_subnets must also be set)"
  type        = bool
  default     = true
}

variable "db_subnet_group_name" {
  description = "Name of database subnet group"
  type        = string
  default     = null
}

variable "db_subnet_group_tags" {
  description = "Additional tags for the database subnet group"
  type        = map(string)
  default     = {}
}

################################################################################
# Database Network ACLs
################################################################################
variable "db_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for database subnets"
  type        = bool
  default     = false
}

variable "db_inbound_acl_rules" {
  description = "Database subnets inbound network ACL rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "db_outbound_acl_rules" {
  description = "Database subnets outbound network ACL rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "db_acl_tags" {
  description = "Additional tags for the database subnets network ACL"
  type        = map(string)
  default     = {}
}

################################################################################
# Elasticache Subnets
################################################################################
variable "create_cache_subnets" {
  description = "Wheter or not to create cache subnets. Default: `false`"
  type        = bool
  default     = false
}

variable "cache_subnet_enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false`"
  type        = bool
  default     = false
}

variable "cache_subnet_names" {
  description = "Explicit values to use in the Name tag on cache subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "cache_subnet_suffix" {
  description = "Suffix to append to cache subnets name"
  type        = string
  default     = "cache"
}

variable "cache_subnet_tags" {
  description = "Additional tags for the cache subnets"
  type        = map(string)
  default     = {}
}

variable "create_cache_subnet_route_table" {
  description = "Controls if separate route table for cache should be created"
  type        = bool
  default     = false
}

variable "create_cache_internet_gateway_route" {
  description = "Controls if an internet gateway route for public cache access should be created"
  type        = bool
  default     = false
}

variable "create_cache_nat_gateway_route" {
  description = "Controls if a nat gateway route should be created to give internet access to the cache subnets"
  type        = bool
  default     = false
}

variable "cache_route_table_tags" {
  description = "Additional tags for the cache route tables"
  type        = map(string)
  default     = {}
}

variable "create_cache_subnet_group" {
  description = "Controls if cache subnet group should be created"
  type        = bool
  default     = true
}

variable "cache_subnet_group_name" {
  description = "Name of cache subnet group"
  type        = string
  default     = null
}

variable "cache_subnet_group_tags" {
  description = "Additional tags for the cache subnet group"
  type        = map(string)
  default     = {}
}

################################################################################
# Elasticache Network ACLs
################################################################################
variable "cache_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for cache subnets"
  type        = bool
  default     = false
}

variable "cache_inbound_acl_rules" {
  description = "Elasticache subnets inbound network ACL rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "cache_outbound_acl_rules" {
  description = "Elasticache subnets outbound network ACL rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "cache_acl_tags" {
  description = "Additional tags for the cache subnets network ACL"
  type        = map(string)
  default     = {}
}

################################################################################
# EKS Subnets
################################################################################
variable "create_eks_subnets" {
  description = "Wheter or not to create EKS subnets. Default: `false`"
  type        = bool
  default     = false
}

variable "eks_subnet_enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false`"
  type        = bool
  default     = false
}

variable "eks_subnet_suffix" {
  description = "Suffix to append to EKS subnets name"
  type        = string
  default     = "eks"
}

variable "create_eks_subnet_route_table" {
  description = "Controls if separate route table for EKS subnets should be created. Default: `false`"
  type        = bool
  default     = false
}

variable "eks_subnet_tags" {
  description = "Additional tags for the EKS subnets"
  type        = map(string)
  default     = {}
}

variable "eks_subnet_tags_per_az" {
  description = "Additional tags for the EKS subnets where the primary key is the AZ"
  type        = map(map(string))
  default     = {}
}

variable "eks_route_table_tags" {
  description = "Additional tags for the EKS route tables"
  type        = map(string)
  default     = {}
}

################################################################################
# EKS Network ACLs
################################################################################
variable "eks_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for EKS subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "eks_inbound_acl_rules" {
  description = "EKS subnets inbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "eks_outbound_acl_rules" {
  description = "EKS subnets outbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "eks_acl_tags" {
  description = "Additional tags for the EKS subnets network ACL"
  type        = map(string)
  default     = {}
}

################################################################################
# Connectivity Subnets
################################################################################
variable "create_connectivity_subnets" {
  description = "Wheter or not to create Connectivity subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "connectivity_subnet_names" {
  description = "Explicit values to use in the Name tag on Connectivity subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "connectivity_subnet_enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false`"
  type        = bool
  default     = false
}

variable "connectivity_subnet_suffix" {
  description = "Suffix to append to Connectivity subnets name"
  type        = string
  default     = "connectivity"
}

variable "create_connectivity_subnet_route_table" {
  description = "Controls if separate route table for Connectivity subnets should be created. Default: `true`"
  type        = bool
  default     = true
}

variable "create_connectivity_nat_gateway_route" {
  description = "Controls if a nat gateway route should be created to give internet access to the Connectivity subnets"
  type        = bool
  default     = false
}

variable "connectivity_subnet_tags" {
  description = "Additional tags for the Connectivity subnets"
  type        = map(string)
  default     = {}
}

variable "connectivity_subnet_tags_per_az" {
  description = "Additional tags for the Connectivity subnets where the primary key is the AZ"
  type        = map(map(string))
  default     = {}
}

variable "connectivity_route_table_tags" {
  description = "Additional tags for the Connectivity route tables"
  type        = map(string)
  default     = {}
}

################################################################################
# EKS Network ACLs
################################################################################
variable "connectivity_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for Connectivity subnets. Default: `true`"
  type        = bool
  default     = true
}

variable "connectivity_inbound_acl_rules" {
  description = "Connectivity subnets inbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "connectivity_outbound_acl_rules" {
  description = "Connectivity subnets outbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "connectivity_acl_tags" {
  description = "Additional tags for the Connectivity subnets network ACL"
  type        = map(string)
  default     = {}
}

################################################################################
# Internet Gateway
################################################################################
variable "create_igw" {
  description = "Controls if an Internet Gateway is created for public subnets and the related routes that connect them"
  type        = bool
  default     = true
}

variable "create_egress_only_igw" {
  description = "Controls if an Egress Only Internet Gateway is created and its related routes"
  type        = bool
  default     = true
}

variable "igw_tags" {
  description = "Additional tags for the internet gateway"
  type        = map(string)
  default     = {}
}

################################################################################
# NAT Gateway
################################################################################

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks. Default: `true`"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Default: `false`"
  type        = bool
  default     = false
}

variable "reuse_nat_ips" {
  description = "Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external_nat_ip_ids' variable"
  type        = bool
  default     = false
}

variable "external_nat_ip_ids" {
  description = "List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse_nat_ips)"
  type        = list(string)
  default     = []
}

variable "external_nat_ips" {
  description = "List of EIPs to be used for `nat_public_ips` output (used in combination with reuse_nat_ips and external_nat_ip_ids)"
  type        = list(string)
  default     = []
}

variable "nat_gateway_tags" {
  description = "Additional tags for the NAT gateways"
  type        = map(string)
  default     = {}
}

variable "nat_eip_tags" {
  description = "Additional tags for the NAT EIP"
  type        = map(string)
  default = {
    eip-nat = "true"
  }
}

################################################################################
# Customer Gateways
################################################################################

variable "customer_gateways" {
  description = "Maps of Customer Gateway's attributes (BGP ASN and Gateway's Internet-routable external IP address)"
  type        = map(map(any))
  default     = {}
}

variable "customer_gateway_tags" {
  description = "Additional tags for the Customer Gateway"
  type        = map(string)
  default     = {}
}

################################################################################
# Default VPC
################################################################################

variable "manage_default_vpc" {
  description = "Should be true to adopt and manage Default VPC"
  type        = bool
  default     = false
}

variable "default_vpc_name" {
  description = "Name to be used on the Default VPC"
  type        = string
  default     = null
}

variable "default_vpc_enable_dns_support" {
  description = "Should be true to enable DNS support in the Default VPC"
  type        = bool
  default     = true
}

variable "default_vpc_enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the Default VPC"
  type        = bool
  default     = true
}

variable "default_vpc_tags" {
  description = "Additional tags for the Default VPC"
  type        = map(string)
  default     = {}
}

variable "manage_default_security_group" {
  description = "Should be true to adopt and manage default security group"
  type        = bool
  default     = true
}

variable "default_security_group_name" {
  description = "Name to be used on the default security group"
  type        = string
  default     = null
}

variable "default_security_group_ingress" {
  description = "List of maps of ingress rules to set on the default security group"
  type        = list(map(string))
  default     = []
}

variable "default_security_group_egress" {
  description = "List of maps of egress rules to set on the default security group"
  type        = list(map(string))
  default     = []
}

variable "default_security_group_tags" {
  description = "Additional tags for the default security group"
  type        = map(string)
  default     = {}
}

################################################################################
# Default Network ACLs
################################################################################

variable "manage_default_network_acl" {
  description = "Should be true to adopt and manage Default Network ACL"
  type        = bool
  default     = true
}

variable "default_network_acl_name" {
  description = "Name to be used on the Default Network ACL"
  type        = string
  default     = null
}

variable "default_network_acl_ingress" {
  description = "List of maps of ingress rules to set on the Default Network ACL"
  type        = list(map(string))
  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
}

variable "default_network_acl_egress" {
  description = "List of maps of egress rules to set on the Default Network ACL"
  type        = list(map(string))
  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
}

variable "default_network_acl_tags" {
  description = "Additional tags for the Default Network ACL"
  type        = map(string)
  default     = {}
}

################################################################################
# Default Route
################################################################################

variable "manage_default_route_table" {
  description = "Should be true to manage default route table"
  type        = bool
  default     = true
}

variable "default_route_table_name" {
  description = "Name to be used on the default route table"
  type        = string
  default     = null
}

variable "default_route_table_propagating_vgws" {
  description = "List of virtual gateways for propagation"
  type        = list(string)
  default     = []
}

variable "default_route_table_routes" {
  description = "Configuration block of routes. See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table#route"
  type        = list(map(string))
  default     = []
}

variable "default_route_table_tags" {
  description = "Additional tags for the default route table"
  type        = map(string)
  default     = {}
}
