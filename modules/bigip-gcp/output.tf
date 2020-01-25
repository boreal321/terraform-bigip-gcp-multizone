output "mgmt_server_ip_address" {
    value = google_compute_address.mgmt_ext_ip.address
}

output "web_server_ip_address" {
    value = google_compute_instance.internal_web.*.network_interface.0.network_ip
}