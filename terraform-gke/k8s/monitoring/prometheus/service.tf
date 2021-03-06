resource "kubernetes_service" "prometheus" {
  metadata {
    name      = var.app_name
    namespace = var.namespace_name
    labels = {
      app = var.app_name
    }

    annotations = {
      "prometheus.io/scrape" = true
    }
  }

  spec {
    selector = {
      app = var.app_name
    }

    type = "NodePort"

    port {
      name        = "prometheus"
      port        = 9090
      target_port = 9090
    }
  }

  depends_on = [kubernetes_deployment.prometheus]
}