
resource "google_compute_network" "vpc" {
  name                            = var.cluster_name
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false
  depends_on = [null_resource.prep_services]
}


resource "google_compute_subnetwork" "subnet" {
  name                      = var.cluster_name
  ip_cidr_range            = "10.0.0.0/18"
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
  # stack_type       = "IPV4_IPV6"
  # ipv6_access_type = "INTERNAL"

  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = "10.48.0.0/14"
  }
  secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = "10.52.0.0/20" 
  }
}







