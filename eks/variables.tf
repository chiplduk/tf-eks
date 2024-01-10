variable "cluster_name" {
  description = "EKS cluster name"
  default = "main"
}

variable "cluster_version" {
  description = "EKS cluster version"
  default = "1.28"
}

variable "node_instance_types" {
  description = "List of instance types for managed node groups"
  type = list(string)
  default = ["t2.small"]
}