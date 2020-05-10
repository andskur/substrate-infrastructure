resource "kubernetes_config_map" "prometheus_config" {
  metadata {
    name      = format("%s-conf", var.app_name)
    namespace = var.namespace_name
  }

  data = {
    "prometheus.rules"  = file("${path.module}/cfg/prometheus.rules")
    "prometheus.yml"    = file("${path.module}/cfg/prometheus.yml")
  }
}