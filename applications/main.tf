resource "kubectl_manifest" "secure_api" {
  for_each  = toset(data.kubectl_filename_list.manifests_secure_api.matches)
  yaml_body = file(each.value)
}

resource "kubectl_manifest" "curl" {
  for_each  = toset(data.kubectl_filename_list.manifests_curl.matches)
  yaml_body = file(each.value)
}

# Resource below are used to wait for NLB interfaces will be published
resource "time_sleep" "wait_180_seconds" {
  depends_on = [kubectl_manifest.secure_api]
  create_duration = "180s"
}