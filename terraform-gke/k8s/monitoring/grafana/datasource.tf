resource "kubernetes_config_map" "grafana_datasource" {
  metadata {
    name      = format("%s-datasource", var.app_name)
    namespace = var.namespace_name
  }

  data = {
    "datasource.yml"  = file("${path.module}/provisioning/datasources/datasource.yml")
  }
}