module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
      configuration_values = jsonencode({
        enableNetworkPolicy = "true"
      })
    }
  }

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  # Publics subnets used to avoid using NATGW and save money
  subnet_ids               = [for subnet in var.subnet_names : data.terraform_remote_state.vpc.outputs.subnets[subnet]]
  control_plane_subnet_ids = [for subnet in var.subnet_names : data.terraform_remote_state.vpc.outputs.subnets[subnet]]

  eks_managed_node_groups = {
    green = {
      min_size     = 1
      max_size     = 3
      desired_size = 3

      instance_types = var.node_instance_types
      capacity_type  = "SPOT"
    }
  }

  # Kubeshark doesn't work without this rule
  node_security_group_additional_rules = {
    allow_http_between_nodes = {
      description = "Allow TCP 80 between nodes for kubeshark"
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      type        = "ingress"
      self        = true
    }
  }

  create_cloudwatch_log_group = false
  cluster_enabled_log_types = []
  
  authentication_mode	= "API_AND_CONFIG_MAP"

  enable_cluster_creator_admin_permissions = true

  access_entries = {
    # One access entry with a policy associated
    example = {
      kubernetes_groups = ["read-only"]
      principal_arn     = aws_iam_role.eks_cluster_read_only_role_new.arn

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            namespaces = ["secure-api"]
            type       = "namespace"
          }
        }
      }
    }
  }

  depends_on = [ aws_iam_role.eks_cluster_read_only_role_new ]
}