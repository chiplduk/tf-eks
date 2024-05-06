variable "alb_controller_namespace" {
  description = "Namespace for ALB controller"
  default     = "kube-system"
}

variable "bucket_name" {
  description = "Bucket name to get data from remote state"
  type        = string
}