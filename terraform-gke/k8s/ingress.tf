resource "kubernetes_ingress" "main_ingress" {
  metadata {
    name = "main-ingress"

    annotations = {
      "kubernetes.io/ingress.global-static-ip-name" = trimsuffix(var.domain, ".com")
      "ingress.gcp.kubernetes.io/pre-shared-cert"   = trimsuffix(var.domain, ".com")
      "kubernetes.io/ingress.allow-http"            = true
      "ingress.kubernetes.io/force-ssl-redirect"    = false
    }
  }

  spec {

    tls {
      hosts = [
        "uddug.com",
        "telemetry.uddug.com"
      ]
      secret_name = "uddug"
    }

    rule {
      host = "telemetry.uddug.com"
      http {
        path {
          path = "/*"
          backend {
            service_name = "telemetry-frontend"
            service_port = "80"
          }
        }
      }
    }
  }
}