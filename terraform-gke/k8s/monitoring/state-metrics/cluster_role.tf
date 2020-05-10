resource "kubernetes_cluster_role" "state_metrics" {
  metadata {
    name = var.cluster_role_name
  }
  rule {
    api_groups = [""]

    resources = [
      "configmaps",
      "secrets",
      "nodes",
      "pods",
      "services",
      "resourcequotas",
      "replicationcontrollers",
      "limitranges",
      "persistentvolumeclaims",
      "persistentvolumes",
      "namespaces",
      "endpoints",
    ]

    verbs = ["list", "watch"]
  }

  rule {
    api_groups = ["extensions"]

    resources = [
      "daemonsets",
      "deployments",
      "replicasets"
    ]

    verbs = ["list", "watch"]
  }

  rule {
    api_groups = ["apps"]

    resources = ["statefulsets"]

    verbs = ["list", "watch"]
  }

  rule {
    api_groups = ["batch"]

    resources = [
      "cronjobs",
      "jobs"
    ]

    verbs = ["list", "watch"]
  }

  rule {
    api_groups = ["autoscaling"]

    resources = ["horizontalpodautoscalers"]

    verbs = ["list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "state_metrics" {
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
    name = "kube-state-metrics"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_role" "state_metrics" {
  metadata {
    name      = var.cluster_role_name
    namespace = var.namespace_name
  }

  rule {
    api_groups  = [""]
    resources   = ["pods"]
    verbs       = ["get"]
  }

  rule {
    api_groups      = ["extensions"]
    resources       = ["deployments"]
    resource_names  = [var.app_name]
    verbs           = ["get", "update"]
  }
}


resource "kubernetes_role_binding" "state_metrics" {
  metadata {
    name      = var.cluster_role_name
    namespace = var.namespace_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = format("%s-resizer", var.app_name)
  }

  subject {
    kind      = "ServiceAccount"
    name      = var.app_name
    namespace = var.namespace_name
  }

}


resource "kubernetes_service_account" "state_metrics" {
  metadata {
    name      = var.cluster_role_name
    namespace = var.namespace_name
  }
  automount_service_account_token = true
}
