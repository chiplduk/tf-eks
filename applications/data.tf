data "kubectl_filename_list" "manifests_secure_api" {
  pattern = "./manifests/secure-api/*.yaml"
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
  depends_on = [time_sleep.wait_180_seconds]
}

data "aws_network_interface" "lb" {
  for_each = toset(data.terraform_remote_state.vpc.outputs.public_subnets_ids) 

  filter {
    name   = "description"
    values = ["ELB ${data.aws_lb.ingress.arn_suffix}"]
  }

  filter {
    name   = "subnet-id"
    values = [each.value]
  }
}