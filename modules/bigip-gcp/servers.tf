resource "google_compute_instance" "internal_web" {
  count        = var.web_count
  name         = "web-${count.index}"
  machine_type = var.internal_machine_type
  zone         = element(var.zones, count.index)

  tags = ["internal", "http", "ssh"]
  metadata_startup_script = data.template_file.startup-script-template.rendered

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
  machine_type = var.mgmt_machine_type
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
    // assign a public IP address
    access_config {
      nat_ip = google_compute_address.mgmt_ext_ip.address
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.external_subnet.name
  }

  service_account {
    scopes = ["userinfo-email", "compute-rw", "storage-rw"]
  }

/*
  provisioner "file" {
    source      = "${path.cwd}/assets/cfe_gcp.json"
    destination = "/tmp/cfe_gcp.json"
    connection {
      host     = google_compute_address.mgmt_ext_ip.address
      type     = "ssh"
      user     = var.ssh_mgmt_user
      private_key = file(var.ssh_mgmt_key)
    }
  }
  provisioner "file" {
    source      = "${path.cwd}/assets/f5-cloud-failover-0.9.1-1.noarch.rpm"
    destination = "/tmp/f5-cloud-failover-0.9.1-1.noarch.rpm"
    connection {
      host     = google_compute_address.mgmt_ext_ip.address
      type     = "ssh"
      user     = var.ssh_mgmt_user
      private_key = file(var.ssh_mgmt_key)
    }
  }
  provisioner "file" {
    // content    = data.template_file.cfe-install-template.rendered
    source      = "${path.cwd}/assets/cfe-install.sh"
    destination = "/tmp/cfe_install.sh"
    connection {
      host     = google_compute_address.mgmt_ext_ip.address
      type     = "ssh"
      user     = var.ssh_mgmt_user
      private_key = file(var.ssh_mgmt_key)
    }
  }
  */
}

resource "null_resource" mgmt_remote_actions {

  provisioner "file" {
    source      = "${path.cwd}/assets/cfe_gcp.json"
    destination = "/tmp/cfe_gcp.json"
  }

  provisioner "file" {
    source      = "${path.cwd}/assets/f5-cloud-failover-1.0.0-0.noarch.rpm"
    destination = "/tmp/f5-cloud-failover-1.0.0-0.noarch.rpm"
  }

  provisioner "file" {
    // content    = data.template_file.cfe-install-template.rendered
    source      = "${path.cwd}/assets/cfe_install.sh"
    destination = "/tmp/cfe_install.sh"
  }

  provisioner "file" {
    source      = "${path.cwd}/assets/web_app_rest.json"
    destination = "/tmp/web_app_rest.json"
  }

  provisioner "file" {
    source      = var.ssh_mgmt_key
    destination = "/home/${var.ssh_mgmt_user}/.ssh/id_rsa"
  }
  /*
   * TODO: chmod 600 id_rsa
   */

  connection {
    host     = google_compute_address.mgmt_ext_ip.address
    type     = "ssh"
    user     = var.ssh_mgmt_user
    private_key = file(var.ssh_mgmt_key)
  }
}