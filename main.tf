module "bigip-gcp" {
  source                  = "./modules/bigip-gcp"
  project                 = var.project
  region                  = var.region
  zones                   = ["us-east4-a", "us-east4-b"]
  web_count               = 2
  ssh_mgmt_user           = "granic"
  ssh_mgmt_key            = "~/.ssh/google_compute_engine"
  mgmt_cidr               = "10.1.10.0/24"
  external_cidr           = "10.1.20.0/24"
  internal_cidr           = "10.1.30.0/24"
  external_count          = 1
  external_machine_type   = "f1-micro"
  external_os_image       = "debian-10"
  external_boot_disk_size = "20"
  external_boot_disk_type = "pd-ssd"
  internal_count          = 1
  internal_machine_type   = "f1-micro"
  internal_os_image       = "debian-10"
  internal_boot_disk_size = "20"
  internal_boot_disk_type = "pd-ssd"
}