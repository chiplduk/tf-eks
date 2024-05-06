variable "alb_name" {
  description = "Name of Ingress ALB"
  default     = "dev-eks-ingress"
}

variable "alb_domain_name" {
  description = "Domain name to use in Ingress configuration"
}

variable "certificate_arn" {
  description = "ARN of SSL certificate"
}