#####################################################################
# Google Cloud Platform
#####################################################################
provider "google" {
  project = var.project
  region  = var.location
}

provider "google-beta" {
  project = var.project
  region  = var.location
}

#####################################################################
# Certificates
#####################################################################
resource "google_compute_managed_ssl_certificate" "managed_certificate" {
  provider = google-beta
  name     = element(split(".", var.domain), 0)

  managed {
    domains = [var.domain]
  }
}

#####################################################################
# Reserved Address
#####################################################################
resource "google_compute_global_address" "ingress_ip" {
  name = element(split(".", var.domain), 0)
}

#####################################################################
# DNS
#####################################################################
resource "google_dns_record_set" "dns" {
  name          = "${var.domain}."
  type          = "A"
  ttl           = 300
  managed_zone  = var.managed_zone
  rrdatas       = [google_compute_global_address.ingress_ip.address]
}

#####################################################################
# GKE Cluster
#####################################################################
resource "google_container_cluster" "primary" {
  name                = var.cluster_name
  location            = var.location

  remove_default_node_pool = true
  initial_node_count  = 1


  /*master_authorized_networks_config {
    cidr_blocks {
      cidr_block = var.vpc_cidr_block
    }
  }*/

  addons_config {
    network_policy_config {
      disabled = true
    }
  }

  master_auth {
    username = var.username
    password = var.password
    client_certificate_config {
      issue_client_certificate = true
    }
  }

  /*private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes = true
    master_ipv4_cidr_block = var.master_ipv4_cidr_block
  }*/

  depends_on = [google_dns_record_set.dns]
}

#####################################################################
# Node Pool
#####################################################################
resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  location   = var.location
  cluster    = google_container_cluster.primary.name
  node_count = 3


  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/compute",
    ]
  }
}

#####################################################################
# Discs
#####################################################################
resource "google_compute_disk" "prometheus_volume" {
  name = "prometheus-volume"
  type = "pd-ssd"
  zone = var.location
  size = 50
}