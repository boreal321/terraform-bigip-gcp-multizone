/*
 * startup script template
 */
data "template_file" "startup-script-template" {
  template = file("${path.cwd}/templates/startup_script_web.tpl.sh")
}
resource "local_file" "startup-script-file" {
  content  = data.template_file.startup-script-template.rendered
  filename = "${path.cwd}/assets/startup_script_web.sh"
}

/*
 * Cloud Failover Extention installation script template
 */
data "template_file" "cfe-install-template" {
  template = file("${path.cwd}/templates/cfe_install.tpl.sh")
  vars = {
    cfe_rpm = "f5-cloud-failover-1.0.0-0.noarch.rpm"
    cfe_json = "cfe_gcp.json"
    bucket = "f5-bigip-storage-bp15"
  }
}
resource "local_file" "cfe-install-file" {
  content  = data.template_file.cfe-install-template.rendered
  filename = "${path.cwd}/assets/cfe_install.sh"
}

/*
 * Cloud Failover Extention JSON declaration template
 */
data "template_file" "cfe-json-template" {
  template = file("${path.cwd}/templates/cfe_gcp.tpl.json")
}
resource "local_file" "cfe-json-file" {
  content  = data.template_file.cfe-json-template.rendered
  filename = "${path.cwd}/assets/cfe_gcp.json"
}

/*
 * web app REST API JSON config template
 */
data "template_file" "web-app-rest-template" {
  template = file("${path.cwd}/templates/web_app_rest.tpl.json")
}
resource "local_file" "web-app-rest-file" {
  content  = data.template_file.web-app-rest-template.rendered
  filename = "${path.cwd}/assets/web_app_rest.json"
}