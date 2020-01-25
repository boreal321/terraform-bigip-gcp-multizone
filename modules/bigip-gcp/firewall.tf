resource "google_compute_firewall" "default_allow_internal_mgmt" {
  name    = "default-allow-internal-mgmt"
  network = google_compute_network.mgmt_vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  priority = "65534"

  source_ranges = ["${var.mgmt_cidr}"]
}
resource "google_compute_firewall" "default_allow_internal_external" {
  name    = "default-allow-internal-external"
  network = google_compute_network.external_vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  priority = "65534"

  source_ranges = [var.external_cidr]
}
resource "google_compute_firewall" "default_allow_internal_internal" {
  name    = "default-allow-internal-internal"
  network = google_compute_network.internal_vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  priority = "65534"

  source_ranges = [var.internal_cidr]
}

resource "google_compute_firewall" "internal_allowed" {
  name    = "internal-allow-ssh"
  network = google_compute_network.internal_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ssh", "http"]
}

resource "google_compute_firewall" "external_allowed" {
  name    = "external-allow-ssh-http"
  network = google_compute_network.external_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  // target_tags = ["ssh", "http"]
}

resource "google_compute_firewall" "mgmt_allowed" {
  name    = "mgmt-allowed"
  network = google_compute_network.mgmt_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ssh", "http"]
}