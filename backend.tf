# Use GCS for Terraform state

terraform {
  backend "gcs" {
    credentials = "credentials.json"
    bucket      = "bigip-terraform-state-bucket"
    prefix      = "lab2"
  }
}

