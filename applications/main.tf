resource "kubectl_manifest" "secure_api" {
  for_each  = toset(data.kubectl_filename_list.manifests_secure_api.matches)
  yaml_body = file(each.value)
}

resource "kubectl_manifest" "curl" {
  for_each  = toset(data.kubectl_filename_list.manifests_curl.matches)
  yaml_body = file(each.value)
}