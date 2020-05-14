#####################################################################
# Variables
#####################################################################
variable "namespace_name" {
  type        = string
  description = "monitoring services namespace"
  default     = "monitoring"
}

variable "cluster_role_name" {
  type        = string
  description = "monitoring services role"
  default     = "monitoring"
}