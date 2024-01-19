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

data "aws_lb" "ingress" {
  name = var.alb_name

  depends_on = [time_sleep.wait_60_seconds]
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

  depends_on = [time_sleep.wait_60_seconds]
}