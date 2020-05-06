variable "backend_name" {
  default = "telemetry-backend"
  type    = string
}

variable "backend_image" {
  default = "andskur/telemetry-backend:latest"
  type    = string
}

variable "backend_port" {
  default = 8000
  type    = number
}

variable "frontend_name" {
  default = "telemetry-frontend"
  type    = string
}

variable "frontend_image" {
  default = "andskur/telemetry-frontend:latest"
  type    = string
}