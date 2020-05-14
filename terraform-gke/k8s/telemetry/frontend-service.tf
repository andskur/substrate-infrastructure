resource "kubernetes_service" "telemetry-frontend" {
  metadata {
    name = var.frontend_name
    labels = {
      app = var.frontend_name
    }
  }

  spec {
    selector = {
      app = var.frontend_name
    }

    session_affinity = "ClientIP"

    port {
      port        = 80
      protocol    = "TCP"
      target_port = 80
    }

    type = "NodePort"
  }
}