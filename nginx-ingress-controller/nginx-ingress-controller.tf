# Install ingress helm chart using terraform
resource "helm_release" "ingress-nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.nginx_ingress_controller_version
  namespace  = kubernetes_namespace.ingress-nginx.metadata.0.name
  depends_on = [
    kubernetes_namespace.ingress-nginx
  ]

  values = [
    file("values/nginx.yaml")
  ]
}