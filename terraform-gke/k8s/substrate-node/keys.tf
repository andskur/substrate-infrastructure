resource "kubernetes_secret" "node_keys" {
  metadata {
    name = format("%s-keys", var.node_name)
    labels = {
      app = var.node_name
    }
  }

  data = {
    KEY_P2P       = var.node_key_p2p
    KEY_MNEMONIC  = var.node_key_mnemonic
    KEY_SR25519   = var.node_key_sr25519
    KEY_ED25519   = var.node_key_ed25519
  }

  type = "Opaque"
}