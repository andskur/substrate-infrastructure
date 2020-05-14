resource "kubernetes_deployment" "telemetry-frontend" {
  metadata {
    name = var.frontend_name
    labels = {
      app = var.frontend_name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.frontend_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.frontend_name
        }
      }

      spec {
        container {
          name  = var.frontend_name
          image = var.frontend_image

          env {
            name  = "SUBSTRATE_TELEMETRY_URL"
            value = "ws://35.228.71.147:8000/feed"
          }

          port {
            container_port = 80
          }
        }
        restart_policy = "Always"
      }
    }
  }
}