#####################################################################
# Variables
#####################################################################
variable "namespace_name" {
  default = "monitoring"
  type    = string
}

variable "cluster_role_name" {
  default = "monitoring"
  type    = string
}

variable "app_name" {
  default = "grafana"
  type    = string
}