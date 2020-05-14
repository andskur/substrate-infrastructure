#####################################################################
# Variables
#####################################################################

variable "project" {
  type        = string
  description = "The project ID where all resources will be launched."
}

variable "domain" {
  type        = string
  description = "the name of domain that will be used"
}

variable "location" {
  type        = string
  description = "The location (region or zone) of the GKE cluster."
}

variable "username" {
  type        = string
  description = "cluster master auth username"
  default     = "admin"
}

variable "password" {
  type        = string
  description = "cluster master auth password"
}

variable "cluster_name" {
  type        = string
  description = "The name of the Kubernetes cluster."
  default     = "example-private-cluster"
}


variable "thrall_key_p2p" {}
variable "thrall_key_mnemonic" {}
variable "thrall_key_sr25519" {}
variable "thrall_key_ed25519" {}

variable "jaina_key_p2p" {}
variable "jaina_key_mnemonic" {}
variable "jaina_key_sr25519" {}
variable "jaina_key_ed25519" {}


variable "arthas_key_p2p" {}
variable "arthas_key_mnemonic" {}
variable "arthas_key_sr25519" {}
variable "arthas_key_ed25519" {}