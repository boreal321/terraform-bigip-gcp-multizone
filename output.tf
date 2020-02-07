output "mgmt_server_ip_address" {
    value = module.bigip-gcp.mgmt_server_ip_address
}


output "web_server_ip_address" {
    value = module.bigip-gcp.web_server_ip_address
}

output "sa_email_address" {
    value = module.bigip-gcp.sa_email_address
}