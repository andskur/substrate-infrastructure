resource "kubernetes_deployment" "node_deployyment" {
  metadata {
    name = var.node_name
    labels = {
      app = var.node_name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.node_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.node_name
        }
      }

      spec {
        container {
          name  = var.node_name
          image = var.node_image

          volume_mount {
            mount_path  = "/data"
            name        = "chain-storage"
          }

          volume_mount {
            mount_path  = "/etc/config"
            name        = "chainspec-volume"
          }

          env {
            name = "KEY_P2P"
            value_from {
              secret_key_ref {
                name  = format("%s-keys", var.node_name)
                key   = "KEY_P2P"
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

          args = var.node_validator? concat(var.cli_arg, ["--validator", "--node-key", "$(KEY_P2P)", "--name", var.node_name]):concat(var.cli_arg, ["--name",var.node_name])

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
            claim_name = format("%s-claim", var.node_name)
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
}