data "aws_availability_zones" "available" {}

locals {
  cluster_name = "main"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"

  name                 = "eks-vpc"
  cidr                 = "10.0.0.0/16"
  secondary_cidr_blocks = ["100.64.0.0/16"]
  azs                  = data.aws_availability_zones.available.names
  public_subnets      = ["100.64.0.0/24", "100.64.1.0/24", "100.64.2.0/24"]
  # public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = false
  single_nat_gateway   = true
  enable_dns_hostnames = true
  map_public_ip_on_launch = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}