variable "bucket_name" {
  description = "Bucket name to get data from remote state"
  type = string
}

variable "nginx_ingress_controller_version" {
  description = "Version of Nginx Ingress Controller"
  type = string
  default = "4.10.0"
}