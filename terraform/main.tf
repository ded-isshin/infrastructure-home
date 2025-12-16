#
# Operating system images for Proxmox block
#

resource "proxmox_virtual_environment_download_file" "images" {
  for_each = local.images

  content_type       = "import"
  datastore_id       = "local"
  node_name          = var.node_name
  url                = each.value.url
  file_name          = each.value.file_name
  checksum           = each.value.checksum
  checksum_algorithm = each.value.checksum_algorithm
}

#
# Cloud-init images for Proxmox block
# https://pve.proxmox.com/pve-docs/pve-admin-guide.html#qm_cloud_init
# https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/configuring_and_managing_cloud-init_for_rhel_9/introduction-to-cloud-init_cloud-content
#

# I decided to use the default configuration via vendor-data, as Proxmox automatically sets the hostname when generating user-data and meta-data. If we use user-data, the hostname is not dynamically set and will be localhost.
# resource "proxmox_virtual_environment_file" "cloud_init_user_data" {
#   content_type = "snippets"
#   datastore_id = "local"
#   node_name    = "pve-hypervisor-prod-01"
#   source_file {
#     path      = "${path.cwd}/data/user-data.yaml"
#     file_name = "user-data.yaml"
#   }
#   overwrite = true
# }

resource "proxmox_virtual_environment_file" "cloud_init_vendor_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.node_name
  source_file {
    path      = "${path.cwd}/data/vendor-data.yaml"
    file_name = "vendor-data.yaml"
  }
  overwrite = true
}

#
# Virtual machines for Proxmox block
#

resource "proxmox_virtual_environment_vm" "machines" {
  for_each = local.machines

  name        = each.key
  description = "Managed by Terraform"
  tags        = each.value.tags
  node_name   = var.node_name

  started         = each.value.started
  protection      = each.value.protection
  stop_on_destroy = true
  agent {
    enabled = true
  }

  bios    = "ovmf"
  machine = "q35"
  # https://github.com/bpg/terraform-provider-proxmox/issues/1770
  serial_device {
    device = "socket"
  }
  scsi_hardware = "virtio-scsi-single"

  # https://forum.proxmox.com/threads/probing-edd-edd-off-ok-when-starting-my-vm.142127/post-732962
  cpu {
    cores = local.instance_type[each.value.instance_type_provider][each.value.instance_type].cpu
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = floor(local.instance_type[each.value.instance_type_provider][each.value.instance_type].mem * 1024) # https://github.com/canonical/lxd/blob/lxd-5.21.4/lxd/instance_instance_types.go#L253
    floating  = floor(local.instance_type[each.value.instance_type_provider][each.value.instance_type].mem * 1024)
  }

  network_device {
    bridge = "vmbr0"
  }

  efi_disk {
    datastore_id = "local-zfs"
    type         = "4m"
  }

  disk {
    datastore_id = "local-zfs"
    import_from  = each.value.disk_import_from
    file_format  = "raw"
    interface    = "scsi0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  ########################################
  # Additional disks (attached disks)
  ########################################
  dynamic "disk" {
    for_each = each.value.extra_disks

    content {
      datastore_id = disk.value.datastore_id
      interface    = disk.value.interface
      size         = disk.value.size

      # Optional but recommended parameters
      iothread = disk.value.iothread
      discard  = disk.value.discard
    }
  }

  initialization {
    datastore_id = "local-zfs"
    dns {
      domain = "home.arpa"
    }
    ip_config {
      ipv4 {
        address = each.value.ip_config_ipv4_address
        gateway = try(each.value.ip_config_ipv4_gateway, null)
      }
    }
    vendor_data_file_id = proxmox_virtual_environment_file.cloud_init_vendor_data.id
    user_account {
      username = "roman"
      keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+x59/CSe6nCTD5RmUV9Nyb5CbDqgYv4MrE97LMxi/cjCqnMs6L2nEdQAAyyyaUsVef1Nz2hRmz1SvPDWopexoB0BwsAUjnDoTE7pGdmvF/ORlES4/83pQMo4f3qMi0rfPM1Z5/BpxgbFWHeOcC9dILvQQ0Ep0p1WZV2boJ9NnZW26XL0+Gi0enpZshR7Y5GMQkrarmP74gkMBYJoChKgkqgHE13/2vkEmX6oafhHVf4LI7MSx21q8Wq2tHaShU1aavZKLmJiTtLvXBFeaUjdFvjicSIc9S/PIFD+szUKmbQMSYsS1FyfDL+TmfZ/Y0a3k7G7Ut9xdjMKEJyy0JNITEnLfFki/tOALVcUypEhR6QoxkLoZzrZfaxqnltC9NnIgTIuEf64BfhR2EO0NYWAlFslEy0MY2XBqGLh7ArAWTfUMC0ur8kn1K323P7WG/M7/3r8uQ+J9aQw3mlm2xUeAMex4C54OitwQiur+64zzzm8EwX9IXjloMvvSMpitSvc= roman@pve-hypervisor-prod-01",
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+ELCx8mHQ8dkQL09KL+OEBvWCCcBsJDMZUp4GGMWWwaf97qfVXFwNWeryNjMfcUYGaMM8lZlXrkeLLFs9bQWonjFzhnSGC94LXMorqig3bmq+UfttJfHxxWbQdRAHZoNOD7Y85T9BOAfwLzbD1Wd5yommiXvYvgzFg7aYzvr13AVIfKW46r/CclYm2/2a0QHa/cScTx4yl88Zz2LqGbLSdUyy2GB/8a8hGipwrmkm3GuJbAVVBiTK6zIjW2WajlZ+m5xEyw+vFo61/j+wBuhh4jgfJhQllS9j1NfW9KQKkgu57koYKIyexg2CxGPAmZQOxAIMYyMZhz8ACpfgu73LFYGbmQ+ubjCJOaU8wYRxUtbLzBx6YkzwbdT1d4mHA0rAk9XhzCcwzYtS+LJAuzhKjiPGmA8lVjACAMFR18zjtSrpF6fidyebyC5amXj4IvC2loZUwUNOqlRd7StZH20E0ihzP3uXbpW/jdVuZWKb31AC+zsxeqOkxrlJKQ5hlMk= roman@macbook.local"
      ]
    }
  }

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  delete_unreferenced_disks_on_destroy = false
}

#
# DNS zones and record for PowerDNS block
#

resource "powerdns_zone" "zones" {
  for_each = local.dns_zones

  name        = each.key
  kind        = each.value.kind
  nameservers = each.value.nameservers
}

resource "powerdns_record" "machines_a_records" {
  for_each = local.machines

  zone = local.dns_zone
  name = "${each.key}.${local.dns_zone}"
  type = local.dns_type
  ttl  = local.dns_ttl

  records = [
  proxmox_virtual_environment_vm.machines[each.key].ipv4_addresses[
    index(proxmox_virtual_environment_vm.machines[each.key].network_interface_names, "eth0")
  ][0]
  ]
}