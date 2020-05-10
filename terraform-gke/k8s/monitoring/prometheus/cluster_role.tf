resource "kubernetes_cluster_role" "metrics_role" {
  metadata {
    name = var.cluster_role_name
  }
  rule {
    api_groups = [""]

    resources = [
      "nodes",
      "nodes/proxy",
      "services",
      "endpoints",
      "pods"
    ]

    verbs = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions"]

    resources = ["ingresses"]

    verbs = ["get", "list", "watch"]
  }

  rule {
    non_resource_urls = ["/metrics"]

    verbs = ["get"]
  }
}

resource "kubernetes_service_account" "metric_cluster_role" {
  metadata {
    name      = var.cluster_role_name
    namespace = var.namespace_name
  }
  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "metric_role" {
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