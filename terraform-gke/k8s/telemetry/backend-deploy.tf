resource "kubernetes_deployment" "telemetry-backend" {
  metadata {
    name = var.backend_name
    labels = {
      app = var.backend_name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.backend_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.backend_name
        }
      }

      spec {
        container {
          name  = var.backend_name
          image = var.backend_image

          env {
            name  = "PORT"
            value = var.backend_port
          }

          port {
            container_port = var.backend_port
          }

          args = [
            "-l",
            format("0.0.0.0:%d", var.backend_port)
          ]
        }
        restart_policy = "Always"
      }
    }
  }
}