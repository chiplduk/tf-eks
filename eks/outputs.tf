output "cluster_name" {
  description = "The EKS cluster name"
  value       = try(module.eks.cluster_name, null)
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN"
  value       = try(module.eks.oidc_provider_arn, null)
}