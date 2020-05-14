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
# GKE Cluster
#####################################################################
resource "google_container_cluster" "primary" {
  name                = var.cluster_name
  location            = var.location

  remove_default_node_pool  = true
  initial_node_count        = 1

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

  depends_on = [google_dns_record_set.dns_a_records]
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

