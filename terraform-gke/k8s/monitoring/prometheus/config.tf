resource "kubernetes_config_map" "prometheus_config" {
  metadata {
    name      = format("%s-conf", var.app_name)
    namespace = var.namespace_name
  }

  data = {
    "prometheus.yml"    = templatefile("${path.module}/cfg/prometheus.tmpl",  local.monitoring_nodes)
  }
}