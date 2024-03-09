data "aws_region" "current" {}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "eksstudybucketforterraformstate"
    key    = "eks/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "eksstudybucketforterraformstate"
    key    = "vpc/terraform.tfstate"
    region = "eu-west-1"
  }
}