resource "kubernetes_deployment" "prometheus" {
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
          image = "prom/prometheus"
          args = [
            "--config.file=/etc/prometheus/prometheus.yml",
            "--storage.tsdb.path=/prometheus/"
          ]

          port {
            container_port = 9090
          }

          volume_mount {
            mount_path  = "/etc/prometheus/"
            name        = "prometheus-config-volume"
          }

          volume_mount {
            mount_path  = "/prometheus/"
            name        = "prometheus-storage-volume"
          }
        }

        volume {
          name = "prometheus-config-volume"
          config_map {
            name  = format("%s-conf", var.app_name)
          }
        }

        volume {
          name = "prometheus-storage-volume"
          empty_dir {}
        }
      }
    }
  }
}