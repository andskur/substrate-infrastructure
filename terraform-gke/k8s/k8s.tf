provider "kubernetes" {
  host     = var.host
  username = var.username
  password = var.password

  client_certificate     = base64decode(var.client_certificate)
  client_key             = base64decode(var.client_key)
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  load_config_file       = false
}

module "monitoring" {
  source = "./monitoring"
}


module "telemetry" {
  source   = "./telemetry"
}

module "chain" {
  source = "./substrate-chain"

  nodes = {
    thrall = {
      keys = {
        key_p2p       = var.thrall_key_p2p
        key_mnemonic  = var.thrall_key_mnemonic
        key_sr25519   = var.thrall_key_sr25519
        key_ed25519   = var.thrall_key_ed25519
      }
    }

    jaina = {
      keys = {
        key_p2p       = var.jaina_key_p2p
        key_mnemonic  = var.jaina_key_mnemonic
        key_sr25519   = var.jaina_key_sr25519
        key_ed25519   = var.jaina_key_ed25519
      }
    }


    kairn   = {keys = {}}
    tyrend  = {keys = {}}

    arthas = {
      keys = {
        key_p2p       = var.arthas_key_p2p
        key_mnemonic  = var.arthas_key_mnemonic
        key_sr25519   = var.arthas_key_sr25519
        key_ed25519   = var.arthas_key_ed25519
      }
    }

  }
}


/*
module "thrall" {
  source          = "./substrate-node"
  node_name       = "thrall"
  node_bootnode   = true
  node_validator  = true

  node_key_p2p      = var.thrall_key_p2p
  node_key_mnemonic = var.thrall_key_mnemonic
  node_key_sr25519  = var.thrall_key_sr25519
  node_key_ed25519  = var.thrall_key_ed25519
}

module "jaina" {
  source          = "./substrate-node"
  node_name       = "jaina"
  node_bootnode   = false
  node_validator  = true

  node_key_p2p      = var.jaina_key_p2p
  node_key_mnemonic = var.jaina_key_mnemonic
  node_key_sr25519  = var.jaina_key_sr25519
  node_key_ed25519  = var.jaina_key_ed25519
}

module "kairn" {
  source          = "./substrate-node"
  node_name       = "kairn"
  node_bootnode   = false
  node_validator  = false
}*/
