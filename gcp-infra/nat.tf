resource "google_compute_router_nat" "nat" {
  name   = var.cluster_name
  router = google_compute_router.router.name
  region = "us-central1"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.nat.self_link]
}

resource "google_compute_address" "nat" {
  name         = "nat"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
  depends_on = [null_resource.prep_services]
}

resource "google_compute_router" "router" {
  name    = "router"
  region  = "us-central1"
  network = google_compute_network.vpc.id
}