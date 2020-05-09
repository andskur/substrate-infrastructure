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

resource "kubernetes_cluster_role_binding" "metric_role" {
  metadata {
    name = var.cluster_role_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = var.cluster_role_name
  }

  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = var.namespace_name
  }
}