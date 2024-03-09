vpc_cidr = "100.64.0.0/16"
vpc_name = "eks-vpc"

map_public_ip_on_launch = true

elastic_ips = [
  #    "eip-name",
]

vpc_peering = [
  # {
  #   pcx_name        = "peering-name"
  #   peer_account_id = 1111111111
  #   peer_vpc_id     = "vpc-xxxxxxxx"
  # },
]

endpoints = {
  gateway = [
    # "s3",
    # "dynamodb",
  ]
  "interface" = [
    # "logs",
    # "monitoring",
  ]
}

nat_gateways = [
  # {
  #     eip    = "eip-name"
  #     name   = "natgateway-name"
  #     subnet = "public-subnet-name"
  # }
]

route_tables = [
  {
    name = "public-eks-rt"
    routes = [
      {
        destination = "0.0.0.0/0"
        target_type = "igw"
      },
    ]
  }
]

subnets = [
  {
    az          = "eu-west-1a"
    cidr_block  = "100.64.0.0/24"
    name        = "public-eks-subnet-01"
    route_table = "public-eks-rt"
    nacl        = "public-eks-nacl"
    tags = {
      "kubernetes.io/role/elb" = "1"
    }
  },
  {
    az          = "eu-west-1b"
    cidr_block  = "100.64.1.0/24"
    name        = "public-eks-subnet-02"
    route_table = "public-eks-rt"
    nacl        = "public-eks-nacl"
    tags = {
      "kubernetes.io/role/elb" = "1"
    }
  },
  {
    az          = "eu-west-1c"
    cidr_block  = "100.64.2.0/24"
    name        = "public-eks-subnet-03"
    route_table = "public-eks-rt"
    nacl        = "public-eks-nacl"
    tags = {
      "kubernetes.io/role/elb" = "1"
    }
  }
]

network_acls = [
  {
    name = "public-eks-nacl"
    egress_rules = [
      { # Allow all
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        protocol   = "-1"
        rule_no    = 10
        from_port  = 0
        to_port    = 0
      }
    ]
    ingress_rules = [
      { # Allow all
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        protocol   = "-1"
        rule_no    = 10
        from_port  = 0
        to_port    = 0
      }
    ]
  }
]