#####################################################################
# Discs
#####################################################################
resource "google_compute_disk" "prometheus_volume" {
  name = "prometheus-volume"
  type = "pd-ssd"
  zone = var.location
  size = 20
}

resource "google_compute_disk" "chain_volume" {
  name = "chain-volume"
  type = "pd-ssd"
  zone = var.location
  size = 50
}