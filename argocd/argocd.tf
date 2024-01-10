resource "kubernetes_namespace" "argocd" {  
  metadata {
    name = "argocd"
    labels = {
       "app.kubernetes.io/managed-by" = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-name" = "argocd"
      "meta.helm.sh/release-namespace" = "argocd"
    }
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = kubernetes_namespace.argocd.metadata.0.name
  version          = "5.51.6"

  set {
      name  = "server.service.type"
      value = "ClusterIP"
  }

  depends_on = [
    kubernetes_namespace.argocd
  ]  
}

resource "kubernetes_service" "argogrpc" {
  metadata {
    name = "argogrpc" 
    namespace = kubernetes_namespace.argocd.metadata.0.name
    labels = {
      "app": "argogrpc"
    }
    annotations = {
      "alb.ingress.kubernetes.io/backend-protocol-version": "GRPC"
    }
  }
  spec {
    selector = {
      "app.kubernetes.io/name" = "argocd-server"
    }
    session_affinity = "None"    
    port {
      port        = 443
      target_port = 8080
      protocol = "TCP"
    }

    type = "ClusterIP"
  }
}


resource "kubernetes_ingress_v1" "argocd-ingress" {
  metadata {
    name = "argocd-server-ingress"
    namespace = kubernetes_namespace.argocd.metadata.0.name
    annotations = {
      "kubernetes.io/ingress.class": "alb"
      "alb.ingress.kubernetes.io/load-balancer-name": var.alb_name
      "alb.ingress.kubernetes.io/scheme": "internet-facing"  
      "alb.ingress.kubernetes.io/backend-protocol": "HTTPS"
      "alb.ingress.kubernetes.io/healthcheck-path": "/healthz"
      "alb.ingress.kubernetes.io/target-type": "ip"
      # Use this annotation (which must match a service name) to route traffic to HTTP2 backends.
      "alb.ingress.kubernetes.io/conditions.argogrpc": "[{\"field\":\"http-header\",\"httpHeaderConfig\":{\"httpHeaderName\": \"Content-Type\", \"values\":[\"application/grpc\"]}}]"
      "alb.ingress.kubernetes.io/listen-ports": "[{\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/certificate-arn": "arn:aws:acm:eu-west-1:659192515497:certificate/e4958d34-7ce7-45d6-84e4-accd35b5edb8"
      "alb.ingress.kubernetes.io/group.name": "dev"
    }
  }
  
  spec {
    rule {
      host = "argocd.svc.cluster.aws"
      http {
        path {
          backend {
            service {
              name = "argogrpc"
              port {
                number = 443
              }
            }
          }
          path = "/"
          path_type = "Prefix"
        }

        path {
          backend {
            service {
              name = "argocd-server"
              port {
                number = 443
              }
            }
          }
          path = "/"
          path_type = "Prefix"
        }        
      }
    }
    tls {
      hosts = ["argocd.svc.cluster.aws"]
    }
  }
}

#https://artifacthub.io/packages/helm/argo/argocd-apps
resource "helm_release" "argocd-apps" {
  name             = "argocd-apps"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-apps"
  namespace        = kubernetes_namespace.argocd.metadata.0.name
  version          = "1.4.1"
  

  depends_on = [
    kubernetes_namespace.argocd,
    helm_release.argocd
  ]

  values = [
    file("applications.yaml")
  ]
}

# Resource below are used to wait for ALB interfaces will be published
resource "time_sleep" "wait_60_seconds" {
  depends_on = [helm_release.argocd-apps]

  create_duration = "60s"
}