resource "kubernetes_ingress" "main_ingress" {
  metadata {
    name = "main-ingress"

    annotations = {
      "kubernetes.io/ingress.global-static-ip-name" = trimsuffix(var.domain, ".com")
      "ingress.gcp.kubernetes.io/pre-shared-cert"   = trimsuffix(var.domain, ".com")
      "kubernetes.io/ingress.allow-http"            = false
      "ingress.kubernetes.io/force-ssl-redirect"    = true
    }
  }

  spec {
    rule {
      host = "uddug.com"
      http {
        path {
          path = "/*"
          backend {
            service_name = "telemetry-frontend"
            service_port = "80"
          }
        }

        path {
          path = "/ws/*"
          backend {
            service_name = "telemetry-backend"
            service_port = 8000
          }
        }
      }
    }
  }
}