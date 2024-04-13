data "kubectl_filename_list" "manifests_secure_api" {
  pattern = "./manifests/secure-api/*.yaml"
}

data "kubectl_filename_list" "manifests_curl" {
  pattern = "./manifests/curl/*.yaml"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    key    = "vpc/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "aws_lb" "ingress" {
  tags = {
    "kubernetes.io/service-name" = "ingress/ingress-ingress-nginx-controller"
  }
  depends_on = [helm_release.ingress]
}