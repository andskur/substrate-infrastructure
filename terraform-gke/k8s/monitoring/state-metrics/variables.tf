#####################################################################
# Variables
#####################################################################
variable "namespace_name" {
  type    = string
  default = "monitoring"
}

variable "cluster_role_name" {
  type    = string
  default = "kube-state-metrics"
}

variable "app_name" {
  type    = string
  default = "kube-state-metrics"
}