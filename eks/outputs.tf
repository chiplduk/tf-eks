output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(module.vpc.vpc_id, null)
}

output "public_subnets_ids" {
  description = "The ID of the VPC"
  value = module.vpc.public_subnets
}

output "cluster_name" {
  description = "The EKS cluster name"
  value       = try(module.eks.cluster_name, null)
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN"
  value       = try(module.eks.oidc_provider_arn, null)
}