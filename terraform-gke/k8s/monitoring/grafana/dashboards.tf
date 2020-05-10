resource "kubernetes_config_map" "grafana_dashboard" {
  metadata {
    name      = format("%s-dashboards", var.app_name)
    namespace = var.namespace_name
  }

  data = {
    "dashboards.yml"            = file("${path.module}/provisioning/dashboards/dashboards.yml")
    "substrate-dashboard.json"  = file("${path.module}/provisioning/dashboards/substrate-dashboard.json")
  }
}