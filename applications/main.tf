resource "kubectl_manifest" "secure_api" {
  for_each  = toset(data.kubectl_filename_list.manifests_secure_api.matches)
  yaml_body = file(each.value)
}

resource "kubectl_manifest" "curl" {
  for_each  = toset(data.kubectl_filename_list.manifests_curl.matches)
  yaml_body = file(each.value)
}

resource "kubernetes_service_account" "s3access" {
  metadata {
    name = "s3access"
    annotations = {
      "eks.amazonaws.com/role-arn" = data.terraform_remote_state.eks.outputs.irsa_s3_access_role_arn
    }
  }
}