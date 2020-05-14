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