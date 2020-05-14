resource "kubernetes_storage_class" "node_storage" {
  metadata {
    name  = "fast-chain"
  }

  storage_provisioner = "kubernetes.io/gce-pd"

  parameters = {
    type = "pd-ssd"
  }

  allow_volume_expansion = true
}

resource "kubernetes_persistent_volume" "node_storage" {
  for_each = var.nodes

  metadata {
    name  = format("%s-volume", each.key)
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    capacity = {
      storage = "50Gi"
    }

    persistent_volume_reclaim_policy  = "Retain"
    storage_class_name                = "fast-chain"


    persistent_volume_source {
      gce_persistent_disk {
        pd_name = var.disk_name
        fs_type = "ext4"
      }
    }
  }

  depends_on = [kubernetes_storage_class.node_storage]
}

resource "kubernetes_persistent_volume_claim" "node_storage" {
  for_each = var.nodes

  metadata {
    name  = format("%s-claim", each.key)
    labels = {
      app = each.key
    }

    annotations = {
      "volume.beta.kubernetes.io/storage-class" = "fast"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "20Gi"
      }
    }
  }

  depends_on = [kubernetes_persistent_volume.node_storage]
}
