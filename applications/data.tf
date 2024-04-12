data "kubectl_filename_list" "manifests" {
  pattern = "./manifests/*.yaml"
}