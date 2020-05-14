resource "kubernetes_service" "kube-state-metrics" {
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
    port {
      port        = 8080
      name        = "http-metrics"
      target_port = "http-metrics"
      protocol    = "TCP"
    }

    port {
      port        = 8081
      name        = "telemetry"
      target_port = "telemetry"
      protocol    = "TCP"
    }

    selector = {
      app = var.app_name
    }
  }
}