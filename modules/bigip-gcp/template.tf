data "template_file" "startup-script-template" {
  template = file("${path.cwd}/templates/startup_script_web.tpl.sh")
}

resource "local_file" "startup-script-file" {
  content  = data.template_file.startup-script-template.rendered
  filename = "${path.cwd}/scripts/startup_script_web.sh"
}