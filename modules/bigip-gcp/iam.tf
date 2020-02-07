resource "google_project_iam_custom_role" "bigip_deployment_role" {
  role_id     = "bigip_deployment_role"
  title       = "Role for Deploying BIG-IP"
  permissions = ["compute.forwardingRules.get", "compute.forwardingRules.list", "compute.forwardingRules.setTarget", "compute.instanceGroups.update", "compute.instances.create", "compute.instances.get", "compute.instances.list", "compute.instances.updateNetworkInterface", "compute.instances.use", "compute.networks.updatePolicy", "compute.routes.create", "compute.routes.delete", "compute.routes.get", "compute.routes.list", "compute.targetInstances.get", "compute.targetInstances.list", "compute.targetInstances.use", "storage.buckets.create", "storage.buckets.delete", "storage.buckets.get", "storage.buckets.list", "storage.buckets.update", "storage.objects.create", "storage.objects.delete", "storage.objects.get", "storage.objects.list", "storage.objects.update"]
}

resource "google_service_account" "bigip_deployment_sa" {
  account_id   = "bigip-deployment-sa"
}

resource "google_service_account_iam_binding" "admin-account-iam" {
  service_account_id = "${google_service_account.bigip_deployment_sa.name}"
  role               = "projects/${var.project}/roles/bigip_deployment_role"
}