output "mgmt_server_ip_address" {
    value = module.bigip-gcp.mgmt_server_IP_address
}


output "web_server_ip_address" {
    value = module.bigip-gcp.web_ip_address
}