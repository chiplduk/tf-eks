terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {}
  }

  # backend "s3" {
  #   key    = "eks/terraform.tfstate"
  # }

  cloud {
    organization = "example-org-eed6a7"

    workspaces {
      name = "eks"
    }
  }
}

provider "aws" {}