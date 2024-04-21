# Install ingress helm chart using terraform
resource "helm_release" "ingress" {
  name       = "ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.10.0"
  namespace  = kubernetes_namespace.ingress.metadata.0.name
  depends_on = [
    kubernetes_namespace.ingress
  ]

  values = [
    file("values/nginx.yaml")
  ]
}