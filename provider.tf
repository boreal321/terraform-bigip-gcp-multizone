# Google Provider
provider "google" {
  credentials = "credentials.json"
  project     = var.project
  region      = var.region
  /*
  project     = "f5-gdm-template-testing"
  region      = "us-east4"
  zone        = "us-east4-b"
  */
}

