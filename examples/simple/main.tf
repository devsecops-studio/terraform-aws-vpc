module "vpc" {
  source = "../../"

  name        = "simple"
  cidr_prefix = "10.11"
}
