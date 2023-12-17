# AWS VPC Terraform module

This module aims to pre-define a set of subnets for a VPC. It's definitely not perfect and fits all use cases, however, it's suitable for most common cases. The following table shows subnet allocation:

| Name | Netmask | Useable Address | AZ-1 | AZ-2 | AZ-3 | Note |
|------|:-------:|----------------:|:----:|:----:|:----:|------|
| External Load Balancer (lb-ext) | /25 | 123 | 10.16.0.0/25<br />10.16.0.0 - 10.16.0.127 | 10.16.0.128/25<br />10.16.0.128 - 10.16.0.255 | 10.16.1.0/25<br />10.16.1.0 - 10.16.1.127 | |
| Internal Load Balancer (lb-int) | /23 | 507 | 10.16.2.0/23<br />10.16.2.0 - 10.16.3.255 | 10.16.4.0/23<br />10.16.4.0 - 10.16.5.255 | 10.16.6.0/23<br />10.16.6.0 - 10.16.7.255 | |
| Public EC2 (ec2-pub) | /23 | 507 | 10.16.8.0/23<br />10.16.8.0 - 10.16.9.255 | 10.16.10.0/23<br />10.16.10.0 - 10.16.11.255 | 10.16.12.0/23<br />10.16.12.0 - 10.16.13.255 | |
| Private EC2 (ec2-priv) | /22 | 1019 | 10.16.16.0/22<br />10.16.16.0 - 10.16.19.255 | 10.16.20.0/22<br />10.16.20.0 - 10.16.23.255 | 10.16.24.0/22<br />10.16.24.0 - 10.16.27.255 | |
| ECS | /21 | 2043 | 10.16.40.0/21<br />10.16.40.0 - 10.16.47.255 | 10.16.48.0/21<br />10.16.48.0 - 10.16.55.255 | 10.16.56.0/21<br />10.16.56.0 - 10.16.63.255 | |
| EKS | /19 | 8187 | 10.16.160.0/19<br />10.16.160.0 - 10.16.191.255 | 10.16.192.0/19<br />10.16.192.0 - 10.16.223.255 | 10.16.224.0/19<br />10.16.224.0 - 10.16.255.255 | |
| DB | /21 | 2043 | 10.16.88.0/21<br />10.16.88.0 - 10.16.95.255 | 10.16.96.0/21<br />10.16.96.0 - 10.16.103.255 | 10.16.104.0/21<br />10.16.104.0 - 10.16.111.255 | |
| Cache | /21 | 2043 | 10.16.64.0/21<br />10.16.64.0 - 10.16.71.255 | 10.16.72.0/21<br />10.16.72.0 - 10.16.79.255 | 10.16.80.0/21<br />10.16.80.0 - 10.16.87.255 | |
| Connectivity | /25 | 123 | 10.16.1.128/25<br />10.16.1.128 - 10.16.1.255 | 10.16.14.0/25<br />10.16.14.0 - 10.16.14.127 | 10.16.14.128/25<br />10.16.14.128 - 10.16.14.255 | |
| Others public | /22 | 1019 | 10.16.28.0/22<br />10.16.28.0 - 10.16.31.255 | 10.16.32.0/22<br />10.16.32.0 - 10.16.35.255 | 10.16.36.0/22<br />10.16.36.0 - 10.16.39.255 | |
| Others private | /20 | 4091 | 10.16.112.0/20<br />10.16.112.0 - 10.16.127.255 | 10.16.128.0/20<br />10.16.128.0 - 10.16.143.255 | 10.16.144.0/20<br />10.16.144.0 - 10.16.159.255 | |
| Spare* | /24 | 251 | 10.16.15.0/24<br />10.16.15.0 - 10.16.15.255 | | | Not created and not tied to any specificed AZ

## Development

- Run command below whenever update a module to update the document

  ```bash
  terraform-docs markdown table --output-file README.md --output-mode inject ./
  ```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.64.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.64.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cache_network_acl"></a> [cache\_network\_acl](#module\_cache\_network\_acl) | ./modules/network-acl | n/a |
| <a name="module_connectivity_network_acl"></a> [connectivity\_network\_acl](#module\_connectivity\_network\_acl) | ./modules/network-acl | n/a |
| <a name="module_db_network_acl"></a> [db\_network\_acl](#module\_db\_network\_acl) | ./modules/network-acl | n/a |
| <a name="module_ec2_private_network_acl"></a> [ec2\_private\_network\_acl](#module\_ec2\_private\_network\_acl) | ./modules/network-acl | n/a |
| <a name="module_ec2_public_network_acl"></a> [ec2\_public\_network\_acl](#module\_ec2\_public\_network\_acl) | ./modules/network-acl | n/a |
| <a name="module_ecs_network_acl"></a> [ecs\_network\_acl](#module\_ecs\_network\_acl) | ./modules/network-acl | n/a |
| <a name="module_eks_network_acl"></a> [eks\_network\_acl](#module\_eks\_network\_acl) | ./modules/network-acl | n/a |
| <a name="module_lb_external_network_acl"></a> [lb\_external\_network\_acl](#module\_lb\_external\_network\_acl) | ./modules/network-acl | n/a |
| <a name="module_lb_internal_network_acl"></a> [lb\_internal\_network\_acl](#module\_lb\_internal\_network\_acl) | ./modules/network-acl | n/a |
| <a name="module_others_private_network_acl"></a> [others\_private\_network\_acl](#module\_others\_private\_network\_acl) | ./modules/network-acl | n/a |
| <a name="module_others_public_network_acl"></a> [others\_public\_network\_acl](#module\_others\_public\_network\_acl) | ./modules/network-acl | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_customer_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customer_gateway) | resource |
| [aws_db_subnet_group.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_default_network_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl) | resource |
| [aws_default_route_table.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table) | resource |
| [aws_default_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_default_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc) | resource |
| [aws_egress_only_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/egress_only_internet_gateway) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_elasticache_subnet_group.cache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.cache_egress_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.cache_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.cache_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.connectivity_egress_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.connectivity_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.db_egress_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.db_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.db_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.ec2_private_egress_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.ec2_private_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.ec2_public_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.ecs_egress_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.ecs_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.egress_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.eks_egress_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.eks_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.lb_external_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.others_private_egress_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.others_private_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.others_public_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.private_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.cache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.connectivity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.ec2_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.ec2_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.lb_external](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.lb_internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.others_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.others_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.cache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.cache_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.cache_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.cache_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.connectivity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.db_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.db_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.db_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.ec2_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.ec2_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.lb_external](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.lb_internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.others_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.others_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.cache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.connectivity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.ec2_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.ec2_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.lb_external](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.lb_internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.others_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.others_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_dhcp_options.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options) | resource |
| [aws_vpc_dhcp_options_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association) | resource |
| [aws_vpc_ipv4_cidr_block_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipv4_cidr_block_association) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cache_acl_tags"></a> [cache\_acl\_tags](#input\_cache\_acl\_tags) | Additional tags for the cache subnets network ACL | `map(string)` | `{}` | no |
| <a name="input_cache_dedicated_network_acl"></a> [cache\_dedicated\_network\_acl](#input\_cache\_dedicated\_network\_acl) | Whether to use dedicated network ACL (not default) and custom rules for cache subnets | `bool` | `false` | no |
| <a name="input_cache_inbound_acl_rules"></a> [cache\_inbound\_acl\_rules](#input\_cache\_inbound\_acl\_rules) | Elasticache subnets inbound network ACL rules | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_cache_outbound_acl_rules"></a> [cache\_outbound\_acl\_rules](#input\_cache\_outbound\_acl\_rules) | Elasticache subnets outbound network ACL rules | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_cache_route_table_tags"></a> [cache\_route\_table\_tags](#input\_cache\_route\_table\_tags) | Additional tags for the cache route tables | `map(string)` | `{}` | no |
| <a name="input_cache_subnet_enable_resource_name_dns_a_record_on_launch"></a> [cache\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch](#input\_cache\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false` | `bool` | `false` | no |
| <a name="input_cache_subnet_group_name"></a> [cache\_subnet\_group\_name](#input\_cache\_subnet\_group\_name) | Name of cache subnet group | `string` | `null` | no |
| <a name="input_cache_subnet_group_tags"></a> [cache\_subnet\_group\_tags](#input\_cache\_subnet\_group\_tags) | Additional tags for the cache subnet group | `map(string)` | `{}` | no |
| <a name="input_cache_subnet_names"></a> [cache\_subnet\_names](#input\_cache\_subnet\_names) | Explicit values to use in the Name tag on cache subnets. If empty, Name tags are generated | `list(string)` | `[]` | no |
| <a name="input_cache_subnet_suffix"></a> [cache\_subnet\_suffix](#input\_cache\_subnet\_suffix) | Suffix to append to cache subnets name | `string` | `"cache"` | no |
| <a name="input_cache_subnet_tags"></a> [cache\_subnet\_tags](#input\_cache\_subnet\_tags) | Additional tags for the cache subnets | `map(string)` | `{}` | no |
| <a name="input_cidr_prefix"></a> [cidr\_prefix](#input\_cidr\_prefix) | The prefix IPv4 CIDR block for the VPC | `string` | `"10.0"` | no |
| <a name="input_connectivity_acl_tags"></a> [connectivity\_acl\_tags](#input\_connectivity\_acl\_tags) | Additional tags for the Connectivity subnets network ACL | `map(string)` | `{}` | no |
| <a name="input_connectivity_dedicated_network_acl"></a> [connectivity\_dedicated\_network\_acl](#input\_connectivity\_dedicated\_network\_acl) | Whether to use dedicated network ACL (not default) and custom rules for Connectivity subnets. Default: `true` | `bool` | `true` | no |
| <a name="input_connectivity_inbound_acl_rules"></a> [connectivity\_inbound\_acl\_rules](#input\_connectivity\_inbound\_acl\_rules) | Connectivity subnets inbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_connectivity_outbound_acl_rules"></a> [connectivity\_outbound\_acl\_rules](#input\_connectivity\_outbound\_acl\_rules) | Connectivity subnets outbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_connectivity_route_table_tags"></a> [connectivity\_route\_table\_tags](#input\_connectivity\_route\_table\_tags) | Additional tags for the Connectivity route tables | `map(string)` | `{}` | no |
| <a name="input_connectivity_subnet_enable_resource_name_dns_a_record_on_launch"></a> [connectivity\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch](#input\_connectivity\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false` | `bool` | `false` | no |
| <a name="input_connectivity_subnet_names"></a> [connectivity\_subnet\_names](#input\_connectivity\_subnet\_names) | Explicit values to use in the Name tag on Connectivity subnets. If empty, Name tags are generated | `list(string)` | `[]` | no |
| <a name="input_connectivity_subnet_suffix"></a> [connectivity\_subnet\_suffix](#input\_connectivity\_subnet\_suffix) | Suffix to append to Connectivity subnets name | `string` | `"connectivity"` | no |
| <a name="input_connectivity_subnet_tags"></a> [connectivity\_subnet\_tags](#input\_connectivity\_subnet\_tags) | Additional tags for the Connectivity subnets | `map(string)` | `{}` | no |
| <a name="input_connectivity_subnet_tags_per_az"></a> [connectivity\_subnet\_tags\_per\_az](#input\_connectivity\_subnet\_tags\_per\_az) | Additional tags for the Connectivity subnets where the primary key is the AZ | `map(map(string))` | `{}` | no |
| <a name="input_create_cache_egress_internet_gateway_route"></a> [create\_cache\_egress\_internet\_gateway\_route](#input\_create\_cache\_egress\_internet\_gateway\_route) | Controls if an egress internet gateway route for public cache access should be created | `bool` | `false` | no |
| <a name="input_create_cache_internet_gateway_route"></a> [create\_cache\_internet\_gateway\_route](#input\_create\_cache\_internet\_gateway\_route) | Controls if an internet gateway route for public cache access should be created | `bool` | `false` | no |
| <a name="input_create_cache_nat_gateway_route"></a> [create\_cache\_nat\_gateway\_route](#input\_create\_cache\_nat\_gateway\_route) | Controls if a nat gateway route should be created to give internet access to the cache subnets | `bool` | `false` | no |
| <a name="input_create_cache_subnet_group"></a> [create\_cache\_subnet\_group](#input\_create\_cache\_subnet\_group) | Controls if cache subnet group should be created | `bool` | `true` | no |
| <a name="input_create_cache_subnet_route_table"></a> [create\_cache\_subnet\_route\_table](#input\_create\_cache\_subnet\_route\_table) | Controls if separate route table for cache should be created | `bool` | `false` | no |
| <a name="input_create_cache_subnets"></a> [create\_cache\_subnets](#input\_create\_cache\_subnets) | Wheter or not to create cache subnets. Default: `false` | `bool` | `false` | no |
| <a name="input_create_connectivity_egress_internet_gateway_route"></a> [create\_connectivity\_egress\_internet\_gateway\_route](#input\_create\_connectivity\_egress\_internet\_gateway\_route) | Controls if a egrss internet gateway route should be created to give internet access to the Connectivity subnets | `bool` | `false` | no |
| <a name="input_create_connectivity_nat_gateway_route"></a> [create\_connectivity\_nat\_gateway\_route](#input\_create\_connectivity\_nat\_gateway\_route) | Controls if a nat gateway route should be created to give internet access to the Connectivity subnets | `bool` | `false` | no |
| <a name="input_create_connectivity_subnet_route_table"></a> [create\_connectivity\_subnet\_route\_table](#input\_create\_connectivity\_subnet\_route\_table) | Controls if separate route table for Connectivity subnets should be created. Default: `true` | `bool` | `true` | no |
| <a name="input_create_connectivity_subnets"></a> [create\_connectivity\_subnets](#input\_create\_connectivity\_subnets) | Wheter or not to create Connectivity subnets. Default: `true` | `bool` | `true` | no |
| <a name="input_create_db_egress_internet_gateway_route"></a> [create\_db\_egress\_internet\_gateway\_route](#input\_create\_db\_egress\_internet\_gateway\_route) | Controls if an egrss internet gateway route for public database access should be created | `bool` | `false` | no |
| <a name="input_create_db_internet_gateway_route"></a> [create\_db\_internet\_gateway\_route](#input\_create\_db\_internet\_gateway\_route) | Controls if an internet gateway route for public database access should be created | `bool` | `false` | no |
| <a name="input_create_db_nat_gateway_route"></a> [create\_db\_nat\_gateway\_route](#input\_create\_db\_nat\_gateway\_route) | Controls if a nat gateway route should be created to give internet access to the database subnets | `bool` | `false` | no |
| <a name="input_create_db_subnet_group"></a> [create\_db\_subnet\_group](#input\_create\_db\_subnet\_group) | Controls if database subnet group should be created (n.b. database\_subnets must also be set) | `bool` | `true` | no |
| <a name="input_create_db_subnet_route_table"></a> [create\_db\_subnet\_route\_table](#input\_create\_db\_subnet\_route\_table) | Controls if separate route table for database should be created | `bool` | `false` | no |
| <a name="input_create_db_subnets"></a> [create\_db\_subnets](#input\_create\_db\_subnets) | Wheter or not to create database subnets. Default: `false` | `bool` | `false` | no |
| <a name="input_create_default_route_eigw"></a> [create\_default\_route\_eigw](#input\_create\_default\_route\_eigw) | Controls if a route for Egress Only Internet Gateway is created | `bool` | `true` | no |
| <a name="input_create_ec2_private_subnet_route_table"></a> [create\_ec2\_private\_subnet\_route\_table](#input\_create\_ec2\_private\_subnet\_route\_table) | Controls if separate route table for EC2 private subnets should be created. Default: `false` | `bool` | `false` | no |
| <a name="input_create_ec2_private_subnets"></a> [create\_ec2\_private\_subnets](#input\_create\_ec2\_private\_subnets) | Wheter or not to create EC2 private subnets. Default: `true` | `bool` | `true` | no |
| <a name="input_create_ec2_public_subnet_route_table"></a> [create\_ec2\_public\_subnet\_route\_table](#input\_create\_ec2\_public\_subnet\_route\_table) | Controls if separate route table for EC2 public subnets should be created. Default: `false` | `bool` | `false` | no |
| <a name="input_create_ec2_public_subnets"></a> [create\_ec2\_public\_subnets](#input\_create\_ec2\_public\_subnets) | Wheter or not to create EC2 public subnets. Default: `true` | `bool` | `true` | no |
| <a name="input_create_ecs_subnet_route_table"></a> [create\_ecs\_subnet\_route\_table](#input\_create\_ecs\_subnet\_route\_table) | Controls if separate route table for ECS subnets should be created. Default: `false` | `bool` | `false` | no |
| <a name="input_create_ecs_subnets"></a> [create\_ecs\_subnets](#input\_create\_ecs\_subnets) | Wheter or not to create ECS subnets. Default: `false` | `bool` | `false` | no |
| <a name="input_create_egress_only_igw"></a> [create\_egress\_only\_igw](#input\_create\_egress\_only\_igw) | Controls if an Egress Only Internet Gateway is created | `bool` | `true` | no |
| <a name="input_create_eks_subnet_route_table"></a> [create\_eks\_subnet\_route\_table](#input\_create\_eks\_subnet\_route\_table) | Controls if separate route table for EKS subnets should be created. Default: `false` | `bool` | `false` | no |
| <a name="input_create_eks_subnets"></a> [create\_eks\_subnets](#input\_create\_eks\_subnets) | Wheter or not to create EKS subnets. Default: `false` | `bool` | `false` | no |
| <a name="input_create_igw"></a> [create\_igw](#input\_create\_igw) | Controls if an Internet Gateway is created for public subnets and the related routes that connect them | `bool` | `true` | no |
| <a name="input_create_lb_external_subnet_route_table"></a> [create\_lb\_external\_subnet\_route\_table](#input\_create\_lb\_external\_subnet\_route\_table) | Controls if separate route table for LB external subnets should be created. Default: `false` | `bool` | `false` | no |
| <a name="input_create_lb_external_subnets"></a> [create\_lb\_external\_subnets](#input\_create\_lb\_external\_subnets) | Wheter or not to create LB external subnets. Default: `true` | `bool` | `true` | no |
| <a name="input_create_lb_internal_subnet_route_table"></a> [create\_lb\_internal\_subnet\_route\_table](#input\_create\_lb\_internal\_subnet\_route\_table) | Controls if separate route table for LB internal subnets should be created. Default: `false` | `bool` | `false` | no |
| <a name="input_create_lb_internal_subnets"></a> [create\_lb\_internal\_subnets](#input\_create\_lb\_internal\_subnets) | Wheter or not to create LB internal subnets. Default: `true` | `bool` | `true` | no |
| <a name="input_create_others_private_subnet_route_table"></a> [create\_others\_private\_subnet\_route\_table](#input\_create\_others\_private\_subnet\_route\_table) | Controls if separate route table for others private subnets should be created. Default: `false` | `bool` | `false` | no |
| <a name="input_create_others_private_subnets"></a> [create\_others\_private\_subnets](#input\_create\_others\_private\_subnets) | Wheter or not to create others private subnets. Default: `true` | `bool` | `true` | no |
| <a name="input_create_others_public_subnet_route_table"></a> [create\_others\_public\_subnet\_route\_table](#input\_create\_others\_public\_subnet\_route\_table) | Controls if separate route table for others public subnets should be created. Default: `false` | `bool` | `false` | no |
| <a name="input_create_others_public_subnets"></a> [create\_others\_public\_subnets](#input\_create\_others\_public\_subnets) | Wheter or not to create others public subnets. Default: `true` | `bool` | `true` | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Controls if VPC should be created (it affects almost all resources) | `bool` | `true` | no |
| <a name="input_customer_gateway_tags"></a> [customer\_gateway\_tags](#input\_customer\_gateway\_tags) | Additional tags for the Customer Gateway | `map(string)` | `{}` | no |
| <a name="input_customer_gateways"></a> [customer\_gateways](#input\_customer\_gateways) | Maps of Customer Gateway's attributes (BGP ASN and Gateway's Internet-routable external IP address) | `map(map(any))` | `{}` | no |
| <a name="input_db_acl_tags"></a> [db\_acl\_tags](#input\_db\_acl\_tags) | Additional tags for the database subnets network ACL | `map(string)` | `{}` | no |
| <a name="input_db_dedicated_network_acl"></a> [db\_dedicated\_network\_acl](#input\_db\_dedicated\_network\_acl) | Whether to use dedicated network ACL (not default) and custom rules for database subnets | `bool` | `false` | no |
| <a name="input_db_inbound_acl_rules"></a> [db\_inbound\_acl\_rules](#input\_db\_inbound\_acl\_rules) | Database subnets inbound network ACL rules | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_db_outbound_acl_rules"></a> [db\_outbound\_acl\_rules](#input\_db\_outbound\_acl\_rules) | Database subnets outbound network ACL rules | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_db_route_table_tags"></a> [db\_route\_table\_tags](#input\_db\_route\_table\_tags) | Additional tags for the database route tables | `map(string)` | `{}` | no |
| <a name="input_db_subnet_enable_resource_name_dns_a_record_on_launch"></a> [db\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch](#input\_db\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false` | `bool` | `false` | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | Name of database subnet group | `string` | `null` | no |
| <a name="input_db_subnet_group_tags"></a> [db\_subnet\_group\_tags](#input\_db\_subnet\_group\_tags) | Additional tags for the database subnet group | `map(string)` | `{}` | no |
| <a name="input_db_subnet_names"></a> [db\_subnet\_names](#input\_db\_subnet\_names) | Explicit values to use in the Name tag on database subnets. If empty, Name tags are generated | `list(string)` | `[]` | no |
| <a name="input_db_subnet_suffix"></a> [db\_subnet\_suffix](#input\_db\_subnet\_suffix) | Suffix to append to database subnets name | `string` | `"db"` | no |
| <a name="input_db_subnet_tags"></a> [db\_subnet\_tags](#input\_db\_subnet\_tags) | Additional tags for the database subnets | `map(string)` | `{}` | no |
| <a name="input_default_network_acl_egress"></a> [default\_network\_acl\_egress](#input\_default\_network\_acl\_egress) | List of maps of egress rules to set on the Default Network ACL | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  },<br>  {<br>    "action": "allow",<br>    "from_port": 0,<br>    "ipv6_cidr_block": "::/0",<br>    "protocol": "-1",<br>    "rule_no": 101,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_default_network_acl_ingress"></a> [default\_network\_acl\_ingress](#input\_default\_network\_acl\_ingress) | List of maps of ingress rules to set on the Default Network ACL | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  },<br>  {<br>    "action": "allow",<br>    "from_port": 0,<br>    "ipv6_cidr_block": "::/0",<br>    "protocol": "-1",<br>    "rule_no": 101,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_default_network_acl_name"></a> [default\_network\_acl\_name](#input\_default\_network\_acl\_name) | Name to be used on the Default Network ACL | `string` | `null` | no |
| <a name="input_default_network_acl_tags"></a> [default\_network\_acl\_tags](#input\_default\_network\_acl\_tags) | Additional tags for the Default Network ACL | `map(string)` | `{}` | no |
| <a name="input_default_route_table_name"></a> [default\_route\_table\_name](#input\_default\_route\_table\_name) | Name to be used on the default route table | `string` | `null` | no |
| <a name="input_default_route_table_propagating_vgws"></a> [default\_route\_table\_propagating\_vgws](#input\_default\_route\_table\_propagating\_vgws) | List of virtual gateways for propagation | `list(string)` | `[]` | no |
| <a name="input_default_route_table_routes"></a> [default\_route\_table\_routes](#input\_default\_route\_table\_routes) | Configuration block of routes. See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table#route | `list(map(string))` | `[]` | no |
| <a name="input_default_route_table_tags"></a> [default\_route\_table\_tags](#input\_default\_route\_table\_tags) | Additional tags for the default route table | `map(string)` | `{}` | no |
| <a name="input_default_security_group_egress"></a> [default\_security\_group\_egress](#input\_default\_security\_group\_egress) | List of maps of egress rules to set on the default security group | `list(map(string))` | `[]` | no |
| <a name="input_default_security_group_ingress"></a> [default\_security\_group\_ingress](#input\_default\_security\_group\_ingress) | List of maps of ingress rules to set on the default security group | `list(map(string))` | `[]` | no |
| <a name="input_default_security_group_name"></a> [default\_security\_group\_name](#input\_default\_security\_group\_name) | Name to be used on the default security group | `string` | `null` | no |
| <a name="input_default_security_group_tags"></a> [default\_security\_group\_tags](#input\_default\_security\_group\_tags) | Additional tags for the default security group | `map(string)` | `{}` | no |
| <a name="input_default_vpc_enable_dns_hostnames"></a> [default\_vpc\_enable\_dns\_hostnames](#input\_default\_vpc\_enable\_dns\_hostnames) | Should be true to enable DNS hostnames in the Default VPC | `bool` | `true` | no |
| <a name="input_default_vpc_enable_dns_support"></a> [default\_vpc\_enable\_dns\_support](#input\_default\_vpc\_enable\_dns\_support) | Should be true to enable DNS support in the Default VPC | `bool` | `true` | no |
| <a name="input_default_vpc_name"></a> [default\_vpc\_name](#input\_default\_vpc\_name) | Name to be used on the Default VPC | `string` | `null` | no |
| <a name="input_default_vpc_tags"></a> [default\_vpc\_tags](#input\_default\_vpc\_tags) | Additional tags for the Default VPC | `map(string)` | `{}` | no |
| <a name="input_dhcp_options_domain_name"></a> [dhcp\_options\_domain\_name](#input\_dhcp\_options\_domain\_name) | Specifies DNS name for DHCP options set (requires enable\_dhcp\_options set to true) | `string` | `""` | no |
| <a name="input_dhcp_options_domain_name_servers"></a> [dhcp\_options\_domain\_name\_servers](#input\_dhcp\_options\_domain\_name\_servers) | Specify a list of DNS server addresses for DHCP options set, default to AWS provided (requires enable\_dhcp\_options set to true) | `list(string)` | <pre>[<br>  "AmazonProvidedDNS"<br>]</pre> | no |
| <a name="input_dhcp_options_netbios_name_servers"></a> [dhcp\_options\_netbios\_name\_servers](#input\_dhcp\_options\_netbios\_name\_servers) | Specify a list of netbios servers for DHCP options set (requires enable\_dhcp\_options set to true) | `list(string)` | `[]` | no |
| <a name="input_dhcp_options_netbios_node_type"></a> [dhcp\_options\_netbios\_node\_type](#input\_dhcp\_options\_netbios\_node\_type) | Specify netbios node\_type for DHCP options set (requires enable\_dhcp\_options set to true) | `string` | `""` | no |
| <a name="input_dhcp_options_ntp_servers"></a> [dhcp\_options\_ntp\_servers](#input\_dhcp\_options\_ntp\_servers) | Specify a list of NTP servers for DHCP options set (requires enable\_dhcp\_options set to true) | `list(string)` | `[]` | no |
| <a name="input_dhcp_options_tags"></a> [dhcp\_options\_tags](#input\_dhcp\_options\_tags) | Additional tags for the DHCP option set (requires enable\_dhcp\_options set to true) | `map(string)` | `{}` | no |
| <a name="input_ec2_private_acl_tags"></a> [ec2\_private\_acl\_tags](#input\_ec2\_private\_acl\_tags) | Additional tags for the EC2 private subnets network ACL | `map(string)` | `{}` | no |
| <a name="input_ec2_private_dedicated_network_acl"></a> [ec2\_private\_dedicated\_network\_acl](#input\_ec2\_private\_dedicated\_network\_acl) | Whether to use dedicated network ACL (not default) and custom rules for EC2 private subnets. Default: `true` | `bool` | `true` | no |
| <a name="input_ec2_private_inbound_acl_rules"></a> [ec2\_private\_inbound\_acl\_rules](#input\_ec2\_private\_inbound\_acl\_rules) | EC2 private subnets inbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_ec2_private_outbound_acl_rules"></a> [ec2\_private\_outbound\_acl\_rules](#input\_ec2\_private\_outbound\_acl\_rules) | EC2 private subnets outbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_ec2_private_route_table_tags"></a> [ec2\_private\_route\_table\_tags](#input\_ec2\_private\_route\_table\_tags) | Additional tags for the EC2 private route tables | `map(string)` | `{}` | no |
| <a name="input_ec2_private_subnet_enable_resource_name_dns_a_record_on_launch"></a> [ec2\_private\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch](#input\_ec2\_private\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false` | `bool` | `false` | no |
| <a name="input_ec2_private_subnet_suffix"></a> [ec2\_private\_subnet\_suffix](#input\_ec2\_private\_subnet\_suffix) | Suffix to append to EC2 private subnets name | `string` | `"ec2-priv"` | no |
| <a name="input_ec2_private_subnet_tags"></a> [ec2\_private\_subnet\_tags](#input\_ec2\_private\_subnet\_tags) | Additional tags for the Ec2 private subnets | `map(string)` | `{}` | no |
| <a name="input_ec2_private_subnet_tags_per_az"></a> [ec2\_private\_subnet\_tags\_per\_az](#input\_ec2\_private\_subnet\_tags\_per\_az) | Additional tags for the EC2 subnets where the primary key is the AZ | `map(map(string))` | `{}` | no |
| <a name="input_ec2_public_acl_tags"></a> [ec2\_public\_acl\_tags](#input\_ec2\_public\_acl\_tags) | Additional tags for the EC2 public subnets network ACL | `map(string)` | `{}` | no |
| <a name="input_ec2_public_dedicated_network_acl"></a> [ec2\_public\_dedicated\_network\_acl](#input\_ec2\_public\_dedicated\_network\_acl) | Whether to use dedicated network ACL (not default) and custom rules for EC2 public subnets. Default: `true` | `bool` | `true` | no |
| <a name="input_ec2_public_inbound_acl_rules"></a> [ec2\_public\_inbound\_acl\_rules](#input\_ec2\_public\_inbound\_acl\_rules) | EC2 public subnets inbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_ec2_public_outbound_acl_rules"></a> [ec2\_public\_outbound\_acl\_rules](#input\_ec2\_public\_outbound\_acl\_rules) | EC2 public subnets outbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_ec2_public_route_table_tags"></a> [ec2\_public\_route\_table\_tags](#input\_ec2\_public\_route\_table\_tags) | Additional tags for the EC2 public route tables | `map(string)` | `{}` | no |
| <a name="input_ec2_public_subnet_enable_resource_name_dns_a_record_on_launch"></a> [ec2\_public\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch](#input\_ec2\_public\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false` | `bool` | `false` | no |
| <a name="input_ec2_public_subnet_suffix"></a> [ec2\_public\_subnet\_suffix](#input\_ec2\_public\_subnet\_suffix) | Suffix to append to EC2 public subnets name | `string` | `"ec2-pub"` | no |
| <a name="input_ec2_public_subnet_tags"></a> [ec2\_public\_subnet\_tags](#input\_ec2\_public\_subnet\_tags) | Additional tags for the Ec2 public subnets | `map(string)` | `{}` | no |
| <a name="input_ec2_public_subnet_tags_per_az"></a> [ec2\_public\_subnet\_tags\_per\_az](#input\_ec2\_public\_subnet\_tags\_per\_az) | Additional tags for the EC2 public subnets where the primary key is the AZ | `map(map(string))` | `{}` | no |
| <a name="input_ecs_acl_tags"></a> [ecs\_acl\_tags](#input\_ecs\_acl\_tags) | Additional tags for the ECS subnets network ACL | `map(string)` | `{}` | no |
| <a name="input_ecs_dedicated_network_acl"></a> [ecs\_dedicated\_network\_acl](#input\_ecs\_dedicated\_network\_acl) | Whether to use dedicated network ACL (not default) and custom rules for ECS subnets. Default: `true` | `bool` | `true` | no |
| <a name="input_ecs_inbound_acl_rules"></a> [ecs\_inbound\_acl\_rules](#input\_ecs\_inbound\_acl\_rules) | ECS subnets inbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_ecs_outbound_acl_rules"></a> [ecs\_outbound\_acl\_rules](#input\_ecs\_outbound\_acl\_rules) | ECS subnets outbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_ecs_route_table_tags"></a> [ecs\_route\_table\_tags](#input\_ecs\_route\_table\_tags) | Additional tags for the ECS route tables | `map(string)` | `{}` | no |
| <a name="input_ecs_subnet_enable_resource_name_dns_a_record_on_launch"></a> [ecs\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch](#input\_ecs\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false` | `bool` | `false` | no |
| <a name="input_ecs_subnet_suffix"></a> [ecs\_subnet\_suffix](#input\_ecs\_subnet\_suffix) | Suffix to append to ECS subnets name | `string` | `"ecs"` | no |
| <a name="input_ecs_subnet_tags"></a> [ecs\_subnet\_tags](#input\_ecs\_subnet\_tags) | Additional tags for the ECS subnets | `map(string)` | `{}` | no |
| <a name="input_ecs_subnet_tags_per_az"></a> [ecs\_subnet\_tags\_per\_az](#input\_ecs\_subnet\_tags\_per\_az) | Additional tags for the ECS where the primary key is the AZ | `map(map(string))` | `{}` | no |
| <a name="input_eks_acl_tags"></a> [eks\_acl\_tags](#input\_eks\_acl\_tags) | Additional tags for the EKS subnets network ACL | `map(string)` | `{}` | no |
| <a name="input_eks_dedicated_network_acl"></a> [eks\_dedicated\_network\_acl](#input\_eks\_dedicated\_network\_acl) | Whether to use dedicated network ACL (not default) and custom rules for EKS subnets. Default: `true` | `bool` | `true` | no |
| <a name="input_eks_inbound_acl_rules"></a> [eks\_inbound\_acl\_rules](#input\_eks\_inbound\_acl\_rules) | EKS subnets inbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_eks_outbound_acl_rules"></a> [eks\_outbound\_acl\_rules](#input\_eks\_outbound\_acl\_rules) | EKS subnets outbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_eks_route_table_tags"></a> [eks\_route\_table\_tags](#input\_eks\_route\_table\_tags) | Additional tags for the EKS route tables | `map(string)` | `{}` | no |
| <a name="input_eks_subnet_enable_resource_name_dns_a_record_on_launch"></a> [eks\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch](#input\_eks\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false` | `bool` | `false` | no |
| <a name="input_eks_subnet_suffix"></a> [eks\_subnet\_suffix](#input\_eks\_subnet\_suffix) | Suffix to append to EKS subnets name | `string` | `"eks"` | no |
| <a name="input_eks_subnet_tags"></a> [eks\_subnet\_tags](#input\_eks\_subnet\_tags) | Additional tags for the EKS subnets | `map(string)` | `{}` | no |
| <a name="input_eks_subnet_tags_per_az"></a> [eks\_subnet\_tags\_per\_az](#input\_eks\_subnet\_tags\_per\_az) | Additional tags for the EKS subnets where the primary key is the AZ | `map(map(string))` | `{}` | no |
| <a name="input_enable_dhcp_options"></a> [enable\_dhcp\_options](#input\_enable\_dhcp\_options) | Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type | `bool` | `false` | no |
| <a name="input_enable_dns64"></a> [enable\_dns64](#input\_enable\_dns64) | Indicates whether DNS queries made to the Amazon-provided DNS Resolver in this subnet should return synthetic IPv6 addresses for IPv4-only destinations. Default: `true` | `bool` | `true` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Should be true to enable DNS hostnames in the VPC | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Should be true to enable DNS support in the VPC | `bool` | `true` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Should be true if you want to provision NAT Gateways for each of your private networks. Default: `true` | `bool` | `true` | no |
| <a name="input_enable_network_address_usage_metrics"></a> [enable\_network\_address\_usage\_metrics](#input\_enable\_network\_address\_usage\_metrics) | Determines whether network address usage metrics are enabled for the VPC | `bool` | `null` | no |
| <a name="input_enable_resource_name_dns_aaaa_record_on_launch"></a> [enable\_resource\_name\_dns\_aaaa\_record\_on\_launch](#input\_enable\_resource\_name\_dns\_aaaa\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records. Default: `true` | `bool` | `true` | no |
| <a name="input_external_nat_ip_ids"></a> [external\_nat\_ip\_ids](#input\_external\_nat\_ip\_ids) | List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse\_nat\_ips) | `list(string)` | `[]` | no |
| <a name="input_external_nat_ips"></a> [external\_nat\_ips](#input\_external\_nat\_ips) | List of EIPs to be used for `nat_public_ips` output (used in combination with reuse\_nat\_ips and external\_nat\_ip\_ids) | `list(string)` | `[]` | no |
| <a name="input_igw_tags"></a> [igw\_tags](#input\_igw\_tags) | Additional tags for the internet gateway | `map(string)` | `{}` | no |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | A tenancy option for instances launched into the VPC | `string` | `"default"` | no |
| <a name="input_ipv6_native"></a> [ipv6\_native](#input\_ipv6\_native) | Indicates whether to create an IPv6-only subnet. Default: `false` | `bool` | `false` | no |
| <a name="input_lb_external_acl_tags"></a> [lb\_external\_acl\_tags](#input\_lb\_external\_acl\_tags) | Additional tags for the LB public subnets network ACL | `map(string)` | `{}` | no |
| <a name="input_lb_external_dedicated_network_acl"></a> [lb\_external\_dedicated\_network\_acl](#input\_lb\_external\_dedicated\_network\_acl) | Whether to use dedicated network ACL (not default) and custom rules for LB public subnets. Default: `true` | `bool` | `true` | no |
| <a name="input_lb_external_inbound_acl_rules"></a> [lb\_external\_inbound\_acl\_rules](#input\_lb\_external\_inbound\_acl\_rules) | LB public subnets inbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_lb_external_outbound_acl_rules"></a> [lb\_external\_outbound\_acl\_rules](#input\_lb\_external\_outbound\_acl\_rules) | LB public subnets outbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_lb_external_route_table_tags"></a> [lb\_external\_route\_table\_tags](#input\_lb\_external\_route\_table\_tags) | Additional tags for the Load balancer public route tables | `map(string)` | `{}` | no |
| <a name="input_lb_external_subnet_enable_resource_name_dns_a_record_on_launch"></a> [lb\_external\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch](#input\_lb\_external\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false` | `bool` | `false` | no |
| <a name="input_lb_external_subnet_suffix"></a> [lb\_external\_subnet\_suffix](#input\_lb\_external\_subnet\_suffix) | Suffix to append to Load balancer public subnets name | `string` | `"lb-ext"` | no |
| <a name="input_lb_external_subnet_tags"></a> [lb\_external\_subnet\_tags](#input\_lb\_external\_subnet\_tags) | Additional tags for the Load balancer public subnets | `map(string)` | `{}` | no |
| <a name="input_lb_external_subnet_tags_per_az"></a> [lb\_external\_subnet\_tags\_per\_az](#input\_lb\_external\_subnet\_tags\_per\_az) | Additional tags for the Load balancer public subnets where the primary key is the AZ | `map(map(string))` | `{}` | no |
| <a name="input_lb_internal_acl_tags"></a> [lb\_internal\_acl\_tags](#input\_lb\_internal\_acl\_tags) | Additional tags for the LB private subnets network ACL | `map(string)` | `{}` | no |
| <a name="input_lb_internal_dedicated_network_acl"></a> [lb\_internal\_dedicated\_network\_acl](#input\_lb\_internal\_dedicated\_network\_acl) | Whether to use dedicated network ACL (not default) and custom rules for LB private subnets. Default: `true` | `bool` | `true` | no |
| <a name="input_lb_internal_inbound_acl_rules"></a> [lb\_internal\_inbound\_acl\_rules](#input\_lb\_internal\_inbound\_acl\_rules) | LB private subnets inbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_lb_internal_outbound_acl_rules"></a> [lb\_internal\_outbound\_acl\_rules](#input\_lb\_internal\_outbound\_acl\_rules) | LB private subnets outbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_lb_internal_route_table_tags"></a> [lb\_internal\_route\_table\_tags](#input\_lb\_internal\_route\_table\_tags) | Additional tags for the LB private route tables | `map(string)` | `{}` | no |
| <a name="input_lb_internal_subnet_enable_resource_name_dns_a_record_on_launch"></a> [lb\_internal\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch](#input\_lb\_internal\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false` | `bool` | `false` | no |
| <a name="input_lb_internal_subnet_names"></a> [lb\_internal\_subnet\_names](#input\_lb\_internal\_subnet\_names) | Explicit values to use in the Name tag on LB private subnets. If empty, Name tags are generated | `list(string)` | `[]` | no |
| <a name="input_lb_internal_subnet_suffix"></a> [lb\_internal\_subnet\_suffix](#input\_lb\_internal\_subnet\_suffix) | Suffix to append to LB private subnets name | `string` | `"lb-int"` | no |
| <a name="input_lb_internal_subnet_tags"></a> [lb\_internal\_subnet\_tags](#input\_lb\_internal\_subnet\_tags) | Additional tags for the LB private subnets | `map(string)` | `{}` | no |
| <a name="input_lb_internal_subnet_tags_per_az"></a> [lb\_internal\_subnet\_tags\_per\_az](#input\_lb\_internal\_subnet\_tags\_per\_az) | Additional tags for the LB private subnets where the primary key is the AZ | `map(map(string))` | `{}` | no |
| <a name="input_manage_default_network_acl"></a> [manage\_default\_network\_acl](#input\_manage\_default\_network\_acl) | Should be true to adopt and manage Default Network ACL | `bool` | `true` | no |
| <a name="input_manage_default_route_table"></a> [manage\_default\_route\_table](#input\_manage\_default\_route\_table) | Should be true to manage default route table | `bool` | `true` | no |
| <a name="input_manage_default_security_group"></a> [manage\_default\_security\_group](#input\_manage\_default\_security\_group) | Should be true to adopt and manage default security group | `bool` | `true` | no |
| <a name="input_manage_default_vpc"></a> [manage\_default\_vpc](#input\_manage\_default\_vpc) | Should be true to adopt and manage Default VPC | `bool` | `false` | no |
| <a name="input_map_public_ip_on_ec2_launched"></a> [map\_public\_ip\_on\_ec2\_launched](#input\_map\_public\_ip\_on\_ec2\_launched) | Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is `true` | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all the resources as identifier | `string` | `""` | no |
| <a name="input_nat_eip_tags"></a> [nat\_eip\_tags](#input\_nat\_eip\_tags) | Additional tags for the NAT EIP | `map(string)` | <pre>{<br>  "eip-nat": "true"<br>}</pre> | no |
| <a name="input_nat_gateway_tags"></a> [nat\_gateway\_tags](#input\_nat\_gateway\_tags) | Additional tags for the NAT gateways | `map(string)` | `{}` | no |
| <a name="input_one_nat_gateway_per_az"></a> [one\_nat\_gateway\_per\_az](#input\_one\_nat\_gateway\_per\_az) | Should be true if you want only one NAT Gateway per availability zone. Default: `false` | `bool` | `false` | no |
| <a name="input_others_private_acl_tags"></a> [others\_private\_acl\_tags](#input\_others\_private\_acl\_tags) | Additional tags for the LB public subnets network ACL | `map(string)` | `{}` | no |
| <a name="input_others_private_dedicated_network_acl"></a> [others\_private\_dedicated\_network\_acl](#input\_others\_private\_dedicated\_network\_acl) | Whether to use dedicated network ACL (not default) and custom rules for LB public subnets. Default: `true` | `bool` | `true` | no |
| <a name="input_others_private_inbound_acl_rules"></a> [others\_private\_inbound\_acl\_rules](#input\_others\_private\_inbound\_acl\_rules) | LB public subnets inbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_others_private_outbound_acl_rules"></a> [others\_private\_outbound\_acl\_rules](#input\_others\_private\_outbound\_acl\_rules) | LB public subnets outbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_others_private_route_table_tags"></a> [others\_private\_route\_table\_tags](#input\_others\_private\_route\_table\_tags) | Additional tags for others private route tables | `map(string)` | `{}` | no |
| <a name="input_others_private_subnet_enable_resource_name_dns_a_record_on_launch"></a> [others\_private\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch](#input\_others\_private\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false` | `bool` | `false` | no |
| <a name="input_others_private_subnet_suffix"></a> [others\_private\_subnet\_suffix](#input\_others\_private\_subnet\_suffix) | Suffix to append to Load balancer public subnets name | `string` | `"others-priv"` | no |
| <a name="input_others_private_subnet_tags"></a> [others\_private\_subnet\_tags](#input\_others\_private\_subnet\_tags) | Additional tags for others private public subnets | `map(string)` | `{}` | no |
| <a name="input_others_private_subnet_tags_per_az"></a> [others\_private\_subnet\_tags\_per\_az](#input\_others\_private\_subnet\_tags\_per\_az) | Additional tags for others private subnets where the primary key is the AZ | `map(map(string))` | `{}` | no |
| <a name="input_others_public_acl_tags"></a> [others\_public\_acl\_tags](#input\_others\_public\_acl\_tags) | Additional tags for others public subnets network ACL | `map(string)` | `{}` | no |
| <a name="input_others_public_dedicated_network_acl"></a> [others\_public\_dedicated\_network\_acl](#input\_others\_public\_dedicated\_network\_acl) | Whether to use dedicated network ACL (not default) and custom rules for others public subnets. Default: `true` | `bool` | `true` | no |
| <a name="input_others_public_inbound_acl_rules"></a> [others\_public\_inbound\_acl\_rules](#input\_others\_public\_inbound\_acl\_rules) | others public subnets inbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_others_public_outbound_acl_rules"></a> [others\_public\_outbound\_acl\_rules](#input\_others\_public\_outbound\_acl\_rules) | others public subnets outbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_others_public_route_table_tags"></a> [others\_public\_route\_table\_tags](#input\_others\_public\_route\_table\_tags) | Additional tags for others public route tables | `map(string)` | `{}` | no |
| <a name="input_others_public_subnet_enable_resource_name_dns_a_record_on_launch"></a> [others\_public\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch](#input\_others\_public\_subnet\_enable\_resource\_name\_dns\_a\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false` | `bool` | `false` | no |
| <a name="input_others_public_subnet_suffix"></a> [others\_public\_subnet\_suffix](#input\_others\_public\_subnet\_suffix) | Suffix to append to others public subnets name | `string` | `"other-pub"` | no |
| <a name="input_others_public_subnet_tags"></a> [others\_public\_subnet\_tags](#input\_others\_public\_subnet\_tags) | Additional tags for others public subnets | `map(string)` | `{}` | no |
| <a name="input_others_public_subnet_tags_per_az"></a> [others\_public\_subnet\_tags\_per\_az](#input\_others\_public\_subnet\_tags\_per\_az) | Additional tags for others public subnets where the primary key is the AZ | `map(map(string))` | `{}` | no |
| <a name="input_private_dns_hostname_type_on_launch"></a> [private\_dns\_hostname\_type\_on\_launch](#input\_private\_dns\_hostname\_type\_on\_launch) | The type of hostnames to assign to instances in the subnet at launch. For IPv6-only subnets, an instance DNS name must be based on the instance ID. For dual-stack and IPv4-only subnets, you can specify whether DNS names use the instance IPv4 address or the instance ID. Valid values: `ip-name`, `resource-name`. Default `ip-name` | `string` | `"ip-name"` | no |
| <a name="input_reuse_nat_ips"></a> [reuse\_nat\_ips](#input\_reuse\_nat\_ips) | Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external\_nat\_ip\_ids' variable | `bool` | `false` | no |
| <a name="input_secondary_cidr_blocks"></a> [secondary\_cidr\_blocks](#input\_secondary\_cidr\_blocks) | List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool | `list(string)` | `[]` | no |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Additional tags for the VPC | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azs"></a> [azs](#output\_azs) | A list of availability zones specified as argument to this module |
| <a name="output_connectivity_route_table_ids"></a> [connectivity\_route\_table\_ids](#output\_connectivity\_route\_table\_ids) | List of IDs of Connectivity route tables |
| <a name="output_connectivity_subnet_arns"></a> [connectivity\_subnet\_arns](#output\_connectivity\_subnet\_arns) | List of ARNs of Connectivity subnets |
| <a name="output_connectivity_subnets"></a> [connectivity\_subnets](#output\_connectivity\_subnets) | List of IDs of Connectivity private subnets |
| <a name="output_connectivity_subnets_cidr_blocks"></a> [connectivity\_subnets\_cidr\_blocks](#output\_connectivity\_subnets\_cidr\_blocks) | List of cidr\_blocks of Connectivity subnets |
| <a name="output_default_network_acl_id"></a> [default\_network\_acl\_id](#output\_default\_network\_acl\_id) | The ID of the default network ACL |
| <a name="output_default_route_table_id"></a> [default\_route\_table\_id](#output\_default\_route\_table\_id) | The ID of the default route table |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | The ID of the security group created by default on VPC creation |
| <a name="output_ec2_private_route_table_ids"></a> [ec2\_private\_route\_table\_ids](#output\_ec2\_private\_route\_table\_ids) | List of IDs of EC2 private route tables |
| <a name="output_ec2_private_subnet_arns"></a> [ec2\_private\_subnet\_arns](#output\_ec2\_private\_subnet\_arns) | List of ARNs of EC2 private subnets |
| <a name="output_ec2_private_subnets"></a> [ec2\_private\_subnets](#output\_ec2\_private\_subnets) | List of IDs of EC2 private subnets |
| <a name="output_ec2_private_subnets_cidr_blocks"></a> [ec2\_private\_subnets\_cidr\_blocks](#output\_ec2\_private\_subnets\_cidr\_blocks) | List of cidr\_blocks of EC2 private subnets |
| <a name="output_ec2_public_route_table_ids"></a> [ec2\_public\_route\_table\_ids](#output\_ec2\_public\_route\_table\_ids) | List of IDs of EC2 public route tables |
| <a name="output_ec2_public_subnet_arns"></a> [ec2\_public\_subnet\_arns](#output\_ec2\_public\_subnet\_arns) | List of ARNs of EC2 public subnets |
| <a name="output_ec2_public_subnets"></a> [ec2\_public\_subnets](#output\_ec2\_public\_subnets) | List of IDs of EC2 public subnets |
| <a name="output_ec2_public_subnets_cidr_blocks"></a> [ec2\_public\_subnets\_cidr\_blocks](#output\_ec2\_public\_subnets\_cidr\_blocks) | List of cidr\_blocks of EC2 public subnets |
| <a name="output_ecs_route_table_ids"></a> [ecs\_route\_table\_ids](#output\_ecs\_route\_table\_ids) | List of IDs of ECS route tables |
| <a name="output_ecs_subnet_arns"></a> [ecs\_subnet\_arns](#output\_ecs\_subnet\_arns) | List of ARNs of ECS subnets |
| <a name="output_ecs_subnets"></a> [ecs\_subnets](#output\_ecs\_subnets) | List of IDs of ECS subnets |
| <a name="output_ecs_subnets_cidr_blocks"></a> [ecs\_subnets\_cidr\_blocks](#output\_ecs\_subnets\_cidr\_blocks) | List of cidr\_blocks of ECS subnets |
| <a name="output_lb_external_route_table_ids"></a> [lb\_external\_route\_table\_ids](#output\_lb\_external\_route\_table\_ids) | List of IDs of Load Balancer public route tables |
| <a name="output_lb_external_subnet_arns"></a> [lb\_external\_subnet\_arns](#output\_lb\_external\_subnet\_arns) | List of ARNs of Load Balancer public subnets |
| <a name="output_lb_external_subnets"></a> [lb\_external\_subnets](#output\_lb\_external\_subnets) | List of IDs of Load Balancer public subnets |
| <a name="output_lb_external_subnets_cidr_blocks"></a> [lb\_external\_subnets\_cidr\_blocks](#output\_lb\_external\_subnets\_cidr\_blocks) | List of cidr\_blocks of Load Balancer public subnets |
| <a name="output_lb_internal_route_table_ids"></a> [lb\_internal\_route\_table\_ids](#output\_lb\_internal\_route\_table\_ids) | List of IDs of Load Balancer private route tables |
| <a name="output_lb_internal_subnet_arns"></a> [lb\_internal\_subnet\_arns](#output\_lb\_internal\_subnet\_arns) | List of ARNs of Load Balancer private subnets |
| <a name="output_lb_internal_subnets"></a> [lb\_internal\_subnets](#output\_lb\_internal\_subnets) | List of IDs of Load Balancer private subnets |
| <a name="output_lb_internal_subnets_cidr_blocks"></a> [lb\_internal\_subnets\_cidr\_blocks](#output\_lb\_internal\_subnets\_cidr\_blocks) | List of cidr\_blocks of Load Balancer private subnets |
| <a name="output_name"></a> [name](#output\_name) | The name of the VPC specified as argument to this module |
| <a name="output_nat_ids"></a> [nat\_ids](#output\_nat\_ids) | List of allocation ID of Elastic IPs created for AWS NAT Gateway |
| <a name="output_nat_public_ips"></a> [nat\_public\_ips](#output\_nat\_public\_ips) | List of public Elastic IPs created for AWS NAT Gateway |
| <a name="output_natgw_ids"></a> [natgw\_ids](#output\_natgw\_ids) | List of NAT Gateway IDs |
| <a name="output_others_private_route_table_ids"></a> [others\_private\_route\_table\_ids](#output\_others\_private\_route\_table\_ids) | List of IDs of others private route tables |
| <a name="output_others_private_subnet_arns"></a> [others\_private\_subnet\_arns](#output\_others\_private\_subnet\_arns) | List of ARNs of other private subnets |
| <a name="output_others_private_subnets"></a> [others\_private\_subnets](#output\_others\_private\_subnets) | List of IDs of other private subnets |
| <a name="output_others_private_subnets_cidr_blocks"></a> [others\_private\_subnets\_cidr\_blocks](#output\_others\_private\_subnets\_cidr\_blocks) | List of cidr\_blocks of other private subnets |
| <a name="output_others_public_route_table_ids"></a> [others\_public\_route\_table\_ids](#output\_others\_public\_route\_table\_ids) | List of IDs of others public route tables |
| <a name="output_others_public_subnet_arns"></a> [others\_public\_subnet\_arns](#output\_others\_public\_subnet\_arns) | List of ARNs of other public subnets |
| <a name="output_others_public_subnets"></a> [others\_public\_subnets](#output\_others\_public\_subnets) | List of IDs of other public subnets |
| <a name="output_others_public_subnets_cidr_blocks"></a> [others\_public\_subnets\_cidr\_blocks](#output\_others\_public\_subnets\_cidr\_blocks) | List of cidr\_blocks of other public subnets |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | Private route tables associated with this VPC |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | Public route tables associated with this VPC |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | The ARN of the VPC |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpc_main_route_table_id"></a> [vpc\_main\_route\_table\_id](#output\_vpc\_main\_route\_table\_id) | The ID of the main route table associated with this VPC |
| <a name="output_vpc_owner_id"></a> [vpc\_owner\_id](#output\_vpc\_owner\_id) | The ID of the AWS account that owns the VPC |
| <a name="output_vpc_secondary_cidr_blocks"></a> [vpc\_secondary\_cidr\_blocks](#output\_vpc\_secondary\_cidr\_blocks) | List of secondary CIDR blocks of the VPC |
<!-- END_TF_DOCS -->
