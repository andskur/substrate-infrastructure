#####################################################################
# Output for K8S
#####################################################################
output "client_certificate" {
  description = "Public certificate used by clients to authenticate to the primary endpoint."
  value     = google_container_cluster.primary.master_auth[0].client_certificate
  sensitive = true
}

output "client_key" {
  description = "Private key used by clients to authenticate to the primary endpoint."
  value     = google_container_cluster.primary.master_auth[0].client_key
  sensitive = true
}

output "primary_ca_certificate" {
  description = "The public certificate that is the root of trust for the primary."
  value     = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive = true
}

output "primary_host" {
  description = "The IP address of the primary master."
  value     = google_container_cluster.primary.endpoint
  sensitive = true
}