locals {
  instance_type = yamldecode(file("${path.module}/data/all.yaml"))

  images = {
    almalinux_9 = {
      source_image  = "almalinux/9/cloud/amd64"
      source_remote = "images"
      type          = "virtual-machine"
      architecture  = "amd64"
    }
    centos_9_stream = {
      source_image  = "centos/9-Stream/cloud/amd64"
      source_remote = "images"
      type          = "virtual-machine"
      architecture  = "amd64"
    }
    debian_12 = {
      source_image  = "debian/12/cloud/amd64"
      source_remote = "images"
      type          = "virtual-machine"
      architecture  = "amd64"
    }
    debian_13 = {
      source_image  = "debian/13/cloud/amd64"
      source_remote = "images"
      type          = "virtual-machine"
      architecture  = "amd64"
    }
    rocky_8 = {
      source_image  = "rockylinux/8/cloud/amd64"
      source_remote = "images"
      type          = "virtual-machine"
      architecture  = "amd64"
    }
    rocky_9 = {
      source_image  = "rockylinux/9/cloud/amd64"
      source_remote = "images"
      type          = "virtual-machine"
      architecture  = "amd64"
    }
    ubuntu_22 = {
      source_image  = "22.04/amd64"
      source_remote = "ubuntu"
      type          = "virtual-machine"
      architecture  = "amd64"
    }
    ubuntu_24 = {
      source_image  = "24.04/amd64"
      source_remote = "ubuntu"
      type          = "virtual-machine"
      architecture  = "amd64"
    }
  }

  machines = {
    "dns-powerdns-prod-01" = {
      tags                   = ["terraform", "dns"]
      instance_type_provider = "aws"
      instance_type          = "c5.large"
      image                  = "rocky_9"
      type                   = "virtual-machine"
      ipv4_address           = "192.168.0.20/24"
      ipv4_gateway           = "192.168.0.1"
      extra_volumes          = []
    }
    "pki-vault-prod-01" = {
      tags                   = ["terraform", "pki", "vault"]
      instance_type_provider = "aws"
      instance_type          = "c5.xlarge"
      image                  = "rocky_9"
      type                   = "virtual-machine"
      ipv4_address           = "192.168.0.30/24"
      ipv4_gateway           = "192.168.0.1"
      extra_volumes = [
        {
          pool    = "data-nvme-pool"
          name    = "pki-vault-prod-01-vaultdata"
          size_gb = 40
        }
      ]
    }
    "mgmt-salt-prod-01" = {
      tags              = ["terraform", "mgmt", "salt"]
      instance_type     = "c5.xlarge"
      image             = "rocky_9"
      type              = "virtual-machine"
      ipv4_address      = "192.168.0.35/24"
      ipv4_gateway      = "192.168.0.1"
      root_disk_size_gb = 60
      extra_volumes     = []
    }
    "crypto-bitcoin-prod-01" = {
      tags          = ["terraform", "crypto", "bitcoin"]
      instance_type = "c5.large"
      image         = "rocky_9"
      type          = "virtual-machine"
      ipv4_address      = "192.168.0.50/24"
      ipv4_gateway      = "192.168.0.1"
      extra_volumes = [
        {
          pool    = "data-nvme-pool"
          name    = "crypto-bitcoin-prod-01-btcdata"
          size_gb = 850
        }
      ]
    }
  }

  extra_volumes = {
    for volume in flatten([
      for instance_name, machine in local.machines : [
        for volume_config in try(machine.extra_volumes, []) : {
          name     = volume_config.name
          pool     = volume_config.pool
          size_gb  = volume_config.size_gb
          instance = instance_name
        }
      ]
    ]) : volume.name => volume
  }

  dns_zone = "home.arpa."
  dns_type = "A"
  dns_ttl  = 300
  dns_zones = {
    "home.arpa." = {
      kind        = "Native"
      nameservers = ["dns-powerdns-prod-01.home.arpa."]
    }
  }
}
