resource "kubectl_manifest" "this" {
  for_each  = toset(data.kubectl_filename_list.manifests.matches)
  yaml_body = file(each.value)
}