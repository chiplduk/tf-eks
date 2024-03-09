data "aws_region" "current" {}

data "terraform_remote_state" "vpc" {
  # backend = "s3"
  # config = {
  #   bucket = "eksstudybucketforterraformstate"
  #   key = "vpc/terraform.tfstate"
  #   region = "eu-west-1"
  # }

  backend = "remote"

  config = {
    organization = "example-org-eed6a7"
    workspaces = {
      name = "vpc"
    }
  }
}