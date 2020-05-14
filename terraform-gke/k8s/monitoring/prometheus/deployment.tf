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
        service_account_name            = var.cluster_role_name
        automount_service_account_token = true

        container {
          name  = var.app_name
          image = "prom/prometheus"
          args = [
            "--config.file=/etc/prometheus/prometheus.yml",
            "--storage.tsdb.path=/prometheus/",
            "--web.enable-lifecycle",
            "--storage.tsdb.no-lockfile"
          ]

          port {
            name            = "prometheus"
            container_port  = 9090
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

        security_context {
          fs_group        = 2000
          run_as_non_root = true
          run_as_user     = 1000
        }

        volume {
          name = "prometheus-config-volume"
          config_map {
            name  = format("%s-conf", var.app_name)
          }
        }

        volume {
          name = "prometheus-storage-volume"
          persistent_volume_claim {
            claim_name = "prometheus-claim"
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_service_account.prometheus_account,
    kubernetes_cluster_role_binding.prometheus_role,
    kubernetes_persistent_volume_claim.prometheus_storage,
    kubernetes_config_map.prometheus_config
  ]
}