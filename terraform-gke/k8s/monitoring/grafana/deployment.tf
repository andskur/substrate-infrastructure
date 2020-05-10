resource "kubernetes_deployment" "grafana" {
  metadata {
    name      = var.app_name
    namespace = var.namespace_name
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        container {
          name  = var.app_name
          image = "grafana/grafana"

          port {
            container_port = 3000
          }

          volume_mount {
            mount_path  = "/etc/grafana/provisioning/datasources/"
            name        = "grafana-datasource-volume"
          }

          volume_mount {
            mount_path  = "/etc/grafana/provisioning/dashboards/"
            name        = "graafana-dashboards-volume"
          }

          volume_mount {
            mount_path  = "/var/lib/grafana/"
            name        = "grafana-storage-volume"
          }

        }

        volume {
          name = "grafana-datasource-volume"
          config_map {
            name = format("%s-datasource", var.app_name)
          }
        }

        volume {
          name = "graafana-dashboards-volume"
          config_map {
            name = format("%s-dashboards", var.app_name)
          }
        }

        volume {
          name = "grafana-storage-volume"
          empty_dir {}
        }
      }
    }
  }
}