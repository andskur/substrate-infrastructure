resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace_name
  }
}