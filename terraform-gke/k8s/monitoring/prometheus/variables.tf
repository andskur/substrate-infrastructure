#####################################################################
# Variables
#####################################################################
variable "namespace_name" {
  type    = string
  default = "monitoring"
}

variable "cluster_role_name" {
  type    = string
  default = "monitoring"
}

variable "app_name" {
  type    = string
  default = "prometheus"
}

variable "nodes" {
  type    = list(string)
  default = [ "thrall", "jaina", "kairn"]
}

variable "node_port" {
  type    = number
  default = 9615
}

variable "node_network" {
  type    = string
  default = "local"
}


#####################################################################
# Locals
#####################################################################
locals {
  monitoring_nodes = {
    port: var.node_port
    network: var.node_network
    nodes: var.nodes
  }
}