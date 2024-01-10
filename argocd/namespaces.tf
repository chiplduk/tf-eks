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