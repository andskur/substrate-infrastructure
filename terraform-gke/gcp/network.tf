#####################################################################
# Certificates
#####################################################################
locals {
  domain_name = element(split(".", var.domain), 0)
  dns_name    = "${var.domain}."
}

#####################################################################
# Certificates
#####################################################################
resource "google_compute_managed_ssl_certificate" "managed_certificate" {
  provider = google-beta
  name     = local.domain_name

  managed {
    domains = [var.domain]
  }
}

#####################################################################
# Reserved Address
#####################################################################
resource "google_compute_global_address" "reserved_ip" {
  name = local.domain_name
}

#####################################################################
# DNS
#####################################################################
resource "google_dns_managed_zone" "dns_zone" {
  name        = trimsuffix(var.domain, ".com")
  dns_name    = local.dns_name
  description = "main project dns zone"

  depends_on = [google_compute_global_address.reserved_ip]
}

resource "google_dns_record_set" "dns_a_records" {
  managed_zone  = google_dns_managed_zone.dns_zone.name
  name          = local.dns_name
  type          = "A"
  ttl           = 300
  rrdatas       = [google_compute_global_address.reserved_ip.address]

  depends_on = [google_dns_managed_zone.dns_zone]
}

resource "google_dns_record_set" "dns_cname_telemetry" {
  managed_zone  = google_dns_managed_zone.dns_zone.name
  name          = "telemetry.${google_dns_managed_zone.dns_zone.dns_name}"
  type          = "CNAME"
  ttl           = 300
  rrdatas       = [local.dns_name]

  depends_on = [google_dns_managed_zone.dns_zone]
}