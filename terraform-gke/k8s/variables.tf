#####################################################################
# Variables
#####################################################################
variable "username" {
  default = "admin"
}
variable "password" {}
variable "host" {}
variable client_certificate {}
variable client_key {}
variable cluster_ca_certificate {}


variable "thrall_key_p2p" {}
variable "thrall_key_mnemonic" {}
variable "thrall_key_sr25519" {}
variable "thrall_key_ed25519" {}


variable "jaina_key_p2p" {}
variable "jaina_key_mnemonic" {}
variable "jaina_key_sr25519" {}
variable "jaina_key_ed25519" {}