terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {}
  }

  backend "s3" {
    key    = "vpc/terraform.tfstate"
  }

}

provider "aws" {}