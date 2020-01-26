# Create storage bucket for scripts
resource "google_storage_bucket" "scripts_bucket" {
  name          = "${var.project}-startup-scripts"
  force_destroy = true
}

# Copy startup scripts into the bucket
resource "google_storage_bucket_object" "startup_web" {
  depends_on = [local_file.startup-script-file]
  name       = "startup_script_web.sh"
  source     = "${path.cwd}/assets/startup_script_web.sh"
  bucket     = google_storage_bucket.scripts_bucket.name
}