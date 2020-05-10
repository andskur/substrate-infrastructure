resource "kubernetes_deployment" "kube-state-metrics" {
  metadata {
    name      = var.app_name
    namespace = var.namespace_name
  }

  spec {
    selector {
      match_labels = {
        app = var.app_name
      }
    }

    replicas = 1

    template {
      metadata {
        name    = var.app_name
        labels  = {
          app = var.app_name
        }
      }

      spec {
        service_account_name            = "monitoring"
        automount_service_account_token = true

        container {
          name  = var.app_name
          image = "quay.io/coreos/kube-state-metrics:v1.9.5"

          port {
            container_port  = 8080
            name            = "http-metrics"
          }

          port {
            container_port  = 8081
            name            = "telemetry"
          }

          readiness_probe {
            http_get {
              path = "/healthz"
              port = 8080
            }

            initial_delay_seconds = 5
            timeout_seconds       = 5
          }
        }

        container {
          name  = "addon-resizer"
          image = "k8s.gcr.io/addon-resizer:1.8.3"

          resources {
            limits {
              cpu     = "150m"
              memory  = "50Mi"
            }

            requests {
              cpu     = "150m"
              memory  = "50Mi"
            }
          }

          env {
            name = "MY_POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "MY_POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          command = [
            "/pod_nanny",
            "--container=kube-state-metrics",
            "--cpu=100m",
            "--extra-cpu=1m",
            "--memory=100Mi",
            "--extra-memory=2Mi",
            "--threshold=5",
            "--deployment=kube-state-metrics"
          ]
        }
      }
    }
  }
}