output "mgmt_server_IP_address" {
    value = google_compute_address.mgmt_ext_ip.address
}