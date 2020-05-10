resource "kubernetes_storage_class" "prometheus_storage" {
  metadata {
    name  = "fast"
  }

  storage_provisioner = "kubernetes.io/gce-pd"

  parameters = {
    type = "pd-ssd"
  }

  allow_volume_expansion = true
}

resource "kubernetes_persistent_volume" "prometheus_storage" {
  metadata {
    name  = "data-volume-1"
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    capacity = {
      storage = "50Gi"
    }

    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "fast"


    persistent_volume_source {
      gce_persistent_disk {
        pd_name = "prometheus-volume"
        fs_type = "ext4"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "prometheus_storage" {
  metadata {
    name      = "prometheus-claim"
    namespace = var.namespace_name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "250Gi"
      }
    }
  }
}