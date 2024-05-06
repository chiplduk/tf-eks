resource "kubernetes_namespace" "kubeshark" {
  metadata {
    name = "kubeshark"
    labels = {
      "app.kubernetes.io/managed-by" = "Helm"
    }
  }
}

resource "kubernetes_namespace" "applications" {
  metadata {
    name = "applications"
    labels = {
      "app.kubernetes.io/managed-by" = "Helm"
    }
  }
}

resource "kubernetes_namespace" "secure-api" {
  metadata {
    name = "secure-api"
    labels = {
      "app.kubernetes.io/managed-by" = "Helm"
    }    
  }
}