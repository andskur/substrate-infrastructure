resource "kubernetes_deployment" "node_deployyment" {
  for_each = var.nodes

  metadata {
    name = each.key
    labels = {
      app = each.key
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = each.key
      }
    }

    template {
      metadata {
        labels = {
          app = each.key
        }
      }

      spec {
        container {
          name  = each.key
          image = var.node_image

          volume_mount {
            mount_path  = "/data"
            name        = "chain-storage"
          }

          volume_mount {
            mount_path  = "/etc/config"
            name        = "chainspec-volume"
          }

          dynamic "env" {
            for_each = each.value.keys
            content {
              name = upper(env.key)
              value_from {
                secret_key_ref {
                  name  = format("%s-keys", each.key)
                  key   = upper(env.key)
                }
              }
            }
          }

          port {
            container_port = 3000
            name = "p2p"
          }
          port {
            container_port = 9933
            name = "rpc"
          }
          port {
            container_port = 9944
            name = "ws"
          }

          args = length(each.value.keys) > 0 ? concat(local.cli_args, ["--validator", "--node-key", "$(KEY_P2P)", "--name", each.key]):concat(local.cli_args, ["--name",each.key])

          readiness_probe {
            http_get {
              path = "/health"
              port = "rpc"
            }
            initial_delay_seconds = 10
            period_seconds        = 10
          }
          liveness_probe {
            http_get {
              path = "/health"
              port = "rpc"
            }
            initial_delay_seconds = 10
            period_seconds        = 10
          }
        }

        volume {
          name = "chain-storage"
          persistent_volume_claim {
            claim_name = format("%s-claim", each.key)
          }
        }

        volume {
          name = "chainspec-volume"
          config_map {
            name = "chainspec"
            items {
              key   = "chainSpecRaw.json"
              path  = "chainspec"
            }
          }
        }

        security_context {
          run_as_user = 1000
          fs_group    = 1000
        }
      }
    }
  }

  depends_on = [
    kubernetes_config_map.chainspec,
    kubernetes_persistent_volume.node_storage,
    kubernetes_secret.node_keys
  ]
}