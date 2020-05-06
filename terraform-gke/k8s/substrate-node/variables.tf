#####################################################################
# Variables
#####################################################################
variable "node_name" {
  default = "node"
  type    = string
}

variable "node_image" {
  default = "andskur/substrate:latest"
  type    = string
}

variable "node_bootnode" {
  type    = bool
  default = false
}

variable "node_validator" {
  default = false
  type    = bool
}

variable "node_key_p2p" {
  default = ""
}

variable "node_key_mnemonic"{
  default = ""
}

variable "node_key_sr25519"{
  default = ""
}

variable "node_key_ed25519"{
  default = ""
}

variable "cli_arg" {
  type = list(string)
  default = [
    "--base-path", "/data",
    "--chain", "/etc/config/chainspec",
    "--rpc-cors", "all",
    "--unsafe-rpc-external",
    "--unsafe-ws-external",
  ]
}