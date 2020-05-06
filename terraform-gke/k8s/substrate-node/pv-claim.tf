resource "kubernetes_persistent_volume_claim" "node-pv-claim" {
  metadata {
    name = format("%s-claim", var.node_name)
    labels = {
      app = var.node_name
    }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}
