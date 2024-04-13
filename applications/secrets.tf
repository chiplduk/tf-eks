resource "kubernetes_secret" "tls-secure-api" {
  metadata {
    name      = "tls-secure-api"
    namespace = kubernetes_namespace.secure-api.metadata.0.name
  }
  data = {
    "tls.crt" = "${file("../.certificates/secure-api.crt")}"
    "tls.key" = "${file("../.certificates/secure-api.key")}"
  }
  type = "kubernetes.io/tls"
}

resource "kubernetes_secret" "secure-api-params" {
  metadata {
    name      = "secure-api-params"
    namespace = kubernetes_namespace.secure-api.metadata.0.name
  }
  data = {
    "psp-encryption-salt" = var.PSP_ENCRYPTION_SALT
    "psp-encryption-key"  = var.PSP_ENCRYPTION_KEY
    "hcha-url"            = var.HCHA_URL
    "hcha-port"           = var.HCHA_PORT
    "hc-vault-token"      = var.HC_VAULT_TOKEN
    "hc-vault-accessor"   = var.HC_VAULT_ACCESSOR
  }
  type = "Opaque"
}