variable "node_name" {
  type        = string
  description = "The name of the source node"
  default     = "pve-hypervisor-prod-01"
}

variable "root_disk_size_gb" {
  type        = number
  description = "Default root disk size (GiB) for VMs unless overridden per-machine"
  default     = 20
}
