terraform {
  required_version = ">= 1.0.0"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.5.1"
    }
  }

  backend "s3" {
    key = "ingress-nginx-controller/terraform.tfstate"
  }
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "eks-main"
  }
}    