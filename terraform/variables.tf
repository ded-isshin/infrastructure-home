variable "default_root_disk_size_gb" {
  type        = number
  description = "Default root disk size (GiB) for instances (can be overridden per-machine)"
  default     = 20
}

variable "default_storage_pool_name" {
  type        = string
  description = "Default LXD storage pool name for root disks"
  default     = "fast-nvme-pool"
}

variable "default_lxd_network_name" {
  type        = string
  description = "Default LXD network name for NICs"
  default     = "lxdbr0"
}

variable "default_instance_type_provider" {
  type        = string
  description = "Default instance provider type"
  default     = "aws"
}

variable "default_started" {
  type        = bool
  description = "Default running state for instances (can be overridden per-machine)"
  default     = true
}
