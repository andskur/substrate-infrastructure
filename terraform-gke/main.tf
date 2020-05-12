#####################################################################
# Terraform
#####################################################################
terraform {
  required_version = ">= 0.12.7"
}

#####################################################################
# Variables
#####################################################################
variable "username" {
  default = "admin"
}
variable "password" {}
variable "project" {}
variable "domain" {}
variable "managed_zone" {}
variable "location" {}
variable "cluster_name" {}

variable "thrall_key_p2p" {}
variable "thrall_key_mnemonic" {}
variable "thrall_key_sr25519" {}
variable "thrall_key_ed25519" {}

variable "jaina_key_p2p" {}
variable "jaina_key_mnemonic" {}
variable "jaina_key_sr25519" {}
variable "jaina_key_ed25519" {}


#####################################################################
# Modules
#####################################################################
module "gke" {
  source        = "./gke"
  project       = var.project
  domain        = var.domain
  managed_zone  = var.managed_zone
  location      = var.location
  password      = var.password
  cluster_name  = var.cluster_name
}


module "k8s" {
  source    = "./k8s"
  host      = "https://${module.gke.primary_host}"
  domain    = var.domain
  username  = var.username
  password  = var.password

  client_certificate     = module.gke.client_certificate
  client_key             = module.gke.client_key
  cluster_ca_certificate = module.gke.primary_ca_certificate


  thrall_key_p2p      = var.thrall_key_p2p
  thrall_key_mnemonic = var.thrall_key_mnemonic
  thrall_key_sr25519  =  var.thrall_key_sr25519
  thrall_key_ed25519  =  var.thrall_key_ed25519


  jaina_key_p2p      = var.jaina_key_p2p
  jaina_key_mnemonic = var.jaina_key_mnemonic
  jaina_key_sr25519  =  var.jaina_key_sr25519
  jaina_key_ed25519  =  var.jaina_key_ed25519
}
