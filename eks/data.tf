data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    key    = "vpc/terraform.tfstate"
    region = "eu-west-1"
  }

}