variable "alb_name" {
  description = "Name of Ingress ALB"
  default     = "dev-eks-ingress"
}

variable "bucket_name" {
  description = "Bucket name to get data from remote state"
  type = string
}