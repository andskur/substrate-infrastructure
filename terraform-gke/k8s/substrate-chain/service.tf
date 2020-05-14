resource "kubernetes_service" "node_service" {
  for_each = var.nodes
  
  metadata {
    name = each.key
    labels = {
      app = each.key
    }
  }

  spec {
    selector = {
      app = each.key
    }

    port {
      name        = "rpc"
      protocol    = "TCP"
      port        = 9933
      target_port = 9933
    }

    port {
      name        = "ws"
      protocol    = "TCP"
      port        = 9944
      target_port = 9944
    }

    port {
      name        = "p2p"
      protocol    = "TCP"
      port        = 30333
      target_port = 30333
    }

    port {
      name        = "prometheus"
      protocol    = "TCP"
      port        = 9615
      target_port = 9615
    }

    type = "ClusterIP"
  }
}