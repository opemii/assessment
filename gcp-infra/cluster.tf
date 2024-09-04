resource "google_container_cluster" "primary" {
  name                      = var.cluster_name
  location                 = "us-central1-f"
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.vpc.id
  subnetwork               = google_compute_subnetwork.subnet.id
  deletion_protection = false
  # logging_service          = "logging.googleapis.com/kubernetes"
  # monitoring_service       = "monitoring.googleapis.com/kubernetes"
  # depends_on = [
  #   google_compute_subnetwork.subnetwork,
  # ]
  node_locations = [
    "us-central1-b"
  ]
  networking_mode          = "VPC_NATIVE"
    ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # master_authorized_networks_config {
  #   cidr_blocks {
  #     cidr_block   = "10.0.0.0/18"
  #     display_name = "private-subnet-w-jenkins"
  #   }
  # }

}

resource "google_container_node_pool" "primary_nodes" {
  name       = "general"
  cluster    = var.cluster_name
  location   = "us-central1-f"
  node_count = 2
  node_config {
    preemptible  = false
    machine_type = "e2-medium"
    labels = {
      role = "general"
    }
    disk_size_gb = "20"
    disk_type = "pd-standard"
    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  
  }
  depends_on = [google_container_cluster.primary]
}

resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}

