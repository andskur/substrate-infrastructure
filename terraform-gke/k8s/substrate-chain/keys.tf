resource "kubernetes_secret" "node_keys" {
  count = length(local.validators)

  metadata {
    name = format("%s-keys", local.validators[count.index])
    labels = {
      app = local.validators[count.index]
    }
  }

  data = {
    KEY_P2P       = var.nodes[local.validators[count.index]].keys.key_p2p
    KEY_MNEMONIC  = var.nodes[local.validators[count.index]].keys.key_mnemonic
    KEY_SR25519   = var.nodes[local.validators[count.index]].keys.key_sr25519
    KEY_ED25519   = var.nodes[local.validators[count.index]].keys.key_ed25519
  }

  type = "Opaque"
}