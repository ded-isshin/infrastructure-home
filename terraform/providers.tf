provider "proxmox" {
  # Check PROXMOX_VE_API_TOKEN env
  endpoint = "https://pve-hypervisor-prod-01.local:8006/"
  insecure = true

  ssh {
    agent       = true
    username    = "roman"
    private_key = file("~/.ssh/id_rsa")
  }
}
