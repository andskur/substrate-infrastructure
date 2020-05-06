resource "kubernetes_service" "telemetry-backend" {
  metadata {
    name = var.backend_name
    labels = {
      app = var.backend_name
    }
  }

  spec {
    selector = {
      app = var.backend_name
    }

    session_affinity = "ClientIP"

    port {
      port        = var.backend_port
      protocol    = "TCP"
      target_port = var.backend_port
    }

    type = "LoadBalancer"
  }
}