resource "google_compute_instance" "internal_web" {
  count        = 2
  name         = "web-${count.index}"
  machine_type = var.internal_machine_type
  zone         = element(var.zones, count.index)

  tags = ["internal", "http", "ssh"]

  boot_disk {
    initialize_params {
      image = var.internal_os_image
      size  = var.internal_boot_disk_size
      type  = var.internal_boot_disk_type
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.internal_subnet.name
  }

  service_account {
    scopes = ["userinfo-email", "compute-rw", "storage-rw"]
  }
}

resource "google_compute_instance" "external" {
  name         = "external"
  machine_type = var.external_machine_type
  zone         = var.zones[0]

  tags = ["external", "http", "ssh"]

  boot_disk {
    initialize_params {
      image = var.external_os_image
      size  = var.external_boot_disk_size
      type  = var.external_boot_disk_type
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.external_subnet.name
  }

  service_account {
    scopes = ["userinfo-email", "compute-rw", "storage-rw"]
  }
}

resource "google_compute_instance" "mgmt_server" {
  name         = "mgmt-server"
  machine_type = var.external_machine_type
  zone         = var.zones[0]

  tags = ["external", "http", "ssh"]

  boot_disk {
    initialize_params {
      image = var.external_os_image
      size  = var.external_boot_disk_size
      type  = var.external_boot_disk_type
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.mgmt_subnet.name
  }

  service_account {
    scopes = ["userinfo-email", "compute-rw", "storage-rw"]
  }
}