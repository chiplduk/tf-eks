variable "PSP_ENCRYPTION_SALT" {
  type = string
}

variable "PSP_ENCRYPTION_KEY" {
  type = string
}

variable "HCHA_URL" {
  type = string
}

variable "HCHA_PORT" {
  type = string
}

variable "HC_VAULT_TOKEN" {
  type = string
}

variable "HC_VAULT_ACCESSOR" {
  type = string
}

variable "bucket_name" {
  description = "Bucket name to get data from remote state"
  type = string
}