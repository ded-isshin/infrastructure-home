provider "lxd" {
  accept_remote_certificate    = true
  generate_client_certificates = true
}

provider "powerdns" {
  # Check PDNS_API_KEY env
  server_url = "http://192.168.0.20:8081/"
}
