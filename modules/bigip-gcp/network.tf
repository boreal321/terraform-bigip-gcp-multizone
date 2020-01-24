/* 
 * mgmt vpc and subnet
 */
resource "google_compute_network" "mgmt_vpc" {
  name                    = "mgmt-vpc"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}
resource "google_compute_subnetwork" "mgmt_subnet" {
  name          = "mgmt-subnet"
  ip_cidr_range = var.mgmt_cidr
  region        = var.region
  network       = google_compute_network.mgmt_vpc.self_link
}
/* 
 * Cloud NAT for mgmt_vpc
 */
resource "google_compute_router" "mgmt_router" {
  name    = "mgmt-router"
  region  = var.region
  network = google_compute_network.mgmt_vpc.self_link

  bgp {
    asn = 64514
  }
}
resource "google_compute_router_nat" "mgmt_nat" {
  name                               = "mgmt-router-nat"
  router                             = google_compute_router.mgmt_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

/* 
 * internal vpc and subnet
 */
resource "google_compute_network" "internal_vpc" {
  name                    = "internal-vpc"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}
resource "google_compute_subnetwork" "internal_subnet" {
  name          = "internal-subnet"
  ip_cidr_range = var.internal_cidr
  region        = var.region
  network       = google_compute_network.internal_vpc.self_link
}
/* 
 * Cloud NAT for internal_vpc
 */
resource "google_compute_router" "internal_router" {
  name    = "internal-router"
  region  = var.region
  network = google_compute_network.internal_vpc.self_link

  bgp {
    asn = 64514
  }
}
resource "google_compute_router_nat" "internal_nat" {
  name                               = "internal-router-nat"
  router                             = google_compute_router.internal_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

/* 
 * external vpc and subnet
 */
resource "google_compute_network" "external_vpc" {
  name                    = "external-vpc"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}
resource "google_compute_subnetwork" "external_subnet" {
  name          = "external-subnet"
  ip_cidr_range = var.external_cidr
  region        = var.region
  network       = google_compute_network.external_vpc.self_link
}
/* 
 * Cloud NAT for external_vpc
 */
resource "google_compute_router" "external_router" {
  name    = "external-router"
  region  = var.region
  network = google_compute_network.external_vpc.self_link

  bgp {
    asn = 64514
  }
}
resource "google_compute_router_nat" "external_nat" {
  name                               = "external-router-nat"
  router                             = google_compute_router.external_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}