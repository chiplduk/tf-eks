variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "main"
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.28"
}

variable "node_instance_types" {
  description = "List of instance types for managed node groups"
  type        = list(string)
  default     = ["t2.small"]
}

variable "subnet_names" {
  description = "List of subnet names to deploy EKS cluster"
  type        = list(string)
}