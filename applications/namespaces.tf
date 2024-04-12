resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
  }
}

resource "kubernetes_namespace" "secure-api" {
  metadata {
    name = "secure-api"
  }
}