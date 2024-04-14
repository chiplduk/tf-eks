output "cluster_name" {
  description = "The EKS cluster name"
  value       = try(module.eks.cluster_name, null)
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN"
  value       = try(module.eks.oidc_provider_arn, null)
}

output "oidc_provider_endpoint" {
  description = "OIDC provider URL"
  value       = try(module.eks.oidc_provider, null)
}

output "irsa_s3_access_role_arn" {
  description = "Role to be attached to EKS Service Account"
  value = try(aws_iam_role.irsa_s3_access_role.arn, null)
}