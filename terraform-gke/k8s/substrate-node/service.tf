resource "kubernetes_service" "node_service" {
  metadata {
    name = var.node_name
    labels = {
      app = var.node_name
    }
  }

  spec {
    selector = {
      app = var.node_name
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

  }
}