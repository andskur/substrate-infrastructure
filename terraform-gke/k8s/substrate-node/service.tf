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

    port {
      name        = "prometheus"
      protocol    = "TCP"
      port        = 9615
      target_port = 9615
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "bootnode_service" {
  count = var.node_bootnode ? 1: 0

  metadata {
    name = format("%s-bootnode", var.node_name)
    labels = {
      app = var.node_name
    }
  }

  spec {
    selector = {
      app = var.node_name
    }

    port {
      name        = "p2p"
      protocol    = "TCP"
      port        = 30333
      target_port = 30333
    }

    type = "NodePort"
  }
}