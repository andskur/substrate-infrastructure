resource "kubernetes_service" "prometheus" {
  metadata {
    name      = var.app_name
    namespace = var.namespace_name
    labels = {
      app = var.app_name
    }
  }

  spec {
    selector = {
      app = var.app_name
    }

    type = "NodePort"

    port {
      port        = 9090
      target_port = 9090
    }
  }
}