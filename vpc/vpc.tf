resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    {
      "Name" = var.vpc_name,
    },
    var.tags,
    {
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    }
  )
}

resource "aws_eip" "this" {
  for_each   = toset(var.elastic_ips)
  depends_on = [aws_internet_gateway.this]

  tags = merge(
    {
      "Name" = "${var.vpc_name}:${each.value}",
    },
    var.tags
  )
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = merge(
    var.tags,
    {
      "Name" = "${var.vpc_name}:default"
    }
  )
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    var.tags,
    {
      "Name" = "${var.vpc_name}:default"
    }
  )
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      "Name" = "${var.vpc_name}:default"
    }
  )
}