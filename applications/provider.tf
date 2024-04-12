terraform {
  required_version = ">= 1.0.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.5.1"
    }
  }

  backend "s3" {
    key = "applications/terraform.tfstate"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "eks-main"
}

provider "kubectl" {
  config_path    = "~/.kube/config"
  config_context = "eks-main"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "eks-main"
  }
}    