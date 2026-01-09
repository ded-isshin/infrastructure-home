resource "lxd_cached_image" "images" {
  for_each = local.images

  source_image  = each.value.source_image
  source_remote = each.value.source_remote
  type          = each.value.type
}

resource "lxd_volume" "extra" {
  for_each = local.extra_volumes

  name         = each.value.name
  pool         = each.value.pool
  type         = "custom"
  content_type = "block"

  config = {
    size = format("%dGiB", each.value.size_gb)
  }
}

resource "lxd_instance" "machines" {
  for_each = local.machines

  name  = each.key
  type  = each.value.type
  image = lxd_cached_image.images[each.value.image].fingerprint

  running = try(each.value.started, var.default_started)

  profiles = try(each.value.profiles, ["default"])

  config = each.value.ipv4_address == "dhcp" ? {} : {
    "cloud-init.network-config" = yamlencode({
      version = 2
      ethernets = {
        enp5s0 = {
          dhcp4     = false
          addresses = [each.value.ipv4_address]
          routes = try(each.value.ipv4_gateway, null) != null ? [
            {
              to  = "0.0.0.0/0"
              via = each.value.ipv4_gateway
            }
          ] : []
          nameservers = {
            addresses = ["192.168.0.20", "147.45.43.80"] # From router
          }
        }
      }
    })
  }

  limits = {
    cpu    = tostring(local.instance_type[try(each.value.instance_type_provider, var.default_instance_type_provider)][each.value.instance_type].cpu)
    memory = format("%dMiB", floor(local.instance_type[try(each.value.instance_type_provider, var.default_instance_type_provider)][each.value.instance_type].mem * 1024)) # https://github.com/canonical/lxd/blob/lxd-5.21.4/lxd/instance_instance_types.go#L253
  }

  device {
    name = "root"
    type = "disk"
    properties = {
      path            = "/"
      "boot.priority" = 100
      pool            = var.default_storage_pool_name
      size            = format("%dGiB", try(each.value.root_disk_size_gb, var.default_root_disk_size_gb))
    }
  }

  dynamic "device" {
    for_each = try(each.value.extra_volumes, [])
    content {
      name = device.value.name
      type = "disk"
      properties = {
        pool   = lxd_volume.extra[device.value.name].pool
        source = lxd_volume.extra[device.value.name].name
      }
    }
  }
}

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
    lxd_instance.machines[each.key].ipv4_address
  ]
}
