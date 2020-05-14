resource "kubernetes_job" "import_job" {
  count = length(local.validators)

  metadata {
    name = format("%s-activation", local.validators[count.index])
    labels = {
      app = local.validators[count.index]
    }
  }

  spec {
    template {
      metadata {}

      spec {
        container {
          name                = format("%s-activation",local.validators[count.index])
          image               = "curlimages/curl"
          image_pull_policy   = "IfNotPresent"

          env_from {
            secret_ref {
              name = format("%s-keys", local.validators[count.index])
            }
          }

          volume_mount {
            name        = "import-script"
            mount_path  = "/scripts"
          }

          command = [
            "/bin/sh",
            "-c",
            "echo $(KEY_MNEMONIC) && echo $(KEY_SR25519) && echo $(KEY_ED25519) && cp /scripts/import_keys /tmp/import_keys && cd /tmp && chmod +x import_keys && ls -la && sh import_keys ${format("http://%s:9933", local.validators[count.index])}",
          ]
        }

        volume {
          name = "import-script"
          config_map {
            name = "import-script"
            items {
              key = "import_keys.sh"
              path = "import_keys"
            }
          }
        }

        restart_policy = "Never"
      }
    }
    backoff_limit = 4
  }

  depends_on = [
    kubernetes_secret.node_keys,
    kubernetes_deployment.node_deployyment
  ]
}