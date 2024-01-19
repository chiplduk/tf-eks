variable "vpc_cidr" {
  type        = string
  description = "The CIDR block of the vpc"
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "[ERROR] The name of the vpc_cidr should not be empty."
  }
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS Hostnames"
  default     = true
  validation {
    condition     = contains([true, false], var.enable_dns_hostnames)
    error_message = "[ERROR] The value ${var.enable_dns_hostnames} should be either true or false."
  }
}

variable "enable_dns_support" {
  type        = bool
  description = "Enable DNS Support"
  default     = true
  validation {
    condition     = contains([true, false], var.enable_dns_support)
    error_message = "[ERROR] The value ${var.enable_dns_support} should be either true or false."
  }
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Assign Public ip to Instance"
  default     = false
  validation {
    condition     = contains([true, false], var.map_public_ip_on_launch)
    error_message = "[ERROR] The value ${var.map_public_ip_on_launch} should be either true or false."
  }
}

variable "tags" {
  description = "Custom project tags."
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "Custom vpc tags."
  type        = map(string)
  default     = {}
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  validation {
    condition     = length(var.vpc_name) > 1
    error_message = "[ERROR] The VPC name should not be empty."
  }
}

variable "subnets" {
  description = "List of subnets"
  type = list(object({
    az          = string
    cidr_block  = string
    name        = string
    route_table = string
    tags        = map(string)
    nacl        = string
  }))
}

variable "route_tables" {
  description = "List of route tables"
  type        = list(any)
}

variable "endpoints" {
  description = "Map of interface and gateway endpoints"
  type        = map(any)
}

variable "elastic_ips" {
  description = "List of Elastic IP names"
  type        = list(string)
}

variable "nat_gateways" {
  description = "List of NAT gateways"
  type = list(object({
    eip    = string
    name   = string
    subnet = string
  }))
}

variable "vpc_peering" {
  description = "List of VPC peering connections"
  type = list(object({
    pcx_name        = string
    peer_account_id = number
    peer_vpc_id     = string
  }))
}

variable "network_acls" {
  description = "List of NACLs"
  type        = list(any)
}