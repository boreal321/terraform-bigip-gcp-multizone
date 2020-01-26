data "template_file" "startup-script-template" {
  template = file("${path.cwd}/templates/startup_script_web.tpl.sh")
}
resource "local_file" "startup-script-file" {
  content  = data.template_file.startup-script-template.rendered
  filename = "${path.cwd}/assets/startup_script_web.sh"
}

data "template_file" "cfe-install-template" {
  template = file("${path.cwd}/templates/cfe_install.tpl.sh")
}
resource "local_file" "cfe-install-file" {
  content  = data.template_file.cfe-install-template.rendered
  filename = "${path.cwd}/assets/cfe_install.sh"
}