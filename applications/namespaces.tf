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

resource "kubernetes_namespace" "open-api" {
  metadata {
    name = "open-api"
  }
}