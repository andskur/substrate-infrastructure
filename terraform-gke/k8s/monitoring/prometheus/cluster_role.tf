resource "kubernetes_service_account" "prometheus_account" {
  metadata {
    name      = var.cluster_role_name
    namespace = var.namespace_name
  }
  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "prometheus_role" {
  metadata {
    name = var.cluster_role_name
  }

  subject {
    kind      = "ServiceAccount"
    name      = var.cluster_role_name
    namespace = var.namespace_name
  }

  role_ref {
    kind = "ClusterRole"
    name = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }
}