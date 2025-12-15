locals {
  instance_type = yamldecode(file("${path.module}/data/all.yaml"))

  images = {
    release_20251125_ubuntu_22_jammy_qcow2_img = {
      url                = "https://cloud-images.ubuntu.com/jammy/20251125/jammy-server-cloudimg-amd64.img"
      file_name          = "ubuntu-22-cloudimg-amd64-20251125.qcow2" # need to rename the file to *.qcow2 to indicate the actual file format for import
      checksum           = "2d88657a36372d211deabc5b5660d4ff8d7425f28ed2c98b6447a8110909f1d3"
      checksum_algorithm = "sha256"
    }
    release_20251126_ubuntu_24_noble_qcow2_img = {
      url                = "https://cloud-images.ubuntu.com/noble/20251126/noble-server-cloudimg-amd64.img"
      file_name          = "ubuntu-24-cloudimg-amd64-20251126.qcow2" # need to rename the file to *.qcow2 to indicate the actual file format for import
      checksum           = "8bf11afd901fdec5aad647a8a284243a2a0b80a81ac732ae618ab36afa09f2b4"
      checksum_algorithm = "sha256"
    }
    release_20251112_debian_12_bookworm_qcow2 = {
      url                = "https://cloud.debian.org/images/cloud/bookworm/20251112-2294/debian-12-generic-amd64-20251112-2294.qcow2"
      file_name          = "debian-12-generic-amd64-20251112.qcow2"
      checksum           = "5da221d8f7434ee86145e78a2c60ca45eb4ef8296535e04f6f333193225792aa8ceee3df6aea2b4ee72d6793f7312308a8b0c6a1c7ed4c7c730fa7bda1bc665f"
      checksum_algorithm = "sha512"
    }
    release_20251117_debian_13_trixie_qcow2 = {
      url                = "https://cloud.debian.org/images/cloud/trixie/20251117-2299/debian-13-generic-amd64-20251117-2299.qcow2"
      file_name          = "debian-13-generic-amd64-20251117.qcow2"
      checksum           = "1882f2d0debfb52254db1b0fc850d222fa68470a644a914d181f744ac1511a6caa1835368362db6dee88504a13c726b3ee9de0e43648353f62e90e075f497026"
      checksum_algorithm = "sha512"
    }
    release_20251201_centos_stream_9_qcow2 = {
      url                = "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-x86_64-9-20251201.0.x86_64.qcow2"
      file_name          = "centos-stream-9-genericcloud-amd64-20251201.qcow2"
      checksum           = "75a77d833a2ec47d10d7dfd7dba41dfe3c1be7e7e14ae5ab42563f9fb0e5e2d8"
      checksum_algorithm = "sha256"
    }

    release_20251201_centos_stream_10_qcow2 = {
      url                = "https://cloud.centos.org/centos/10-stream/x86_64/images/CentOS-Stream-GenericCloud-x86_64-10-20251201.0.x86_64.qcow2"
      file_name          = "centos-stream-10-genericcloud-amd64-20251201.qcow2"
      checksum           = "d188b8ea03368b4c2fdbb2c7d34db75ca517dfc0e6c3124ca081c52388dac535"
      checksum_algorithm = "sha256"
    }

    release_20251123_rocky_9_qcow2 = {
      url                = "https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base-9.7-20251123.2.x86_64.qcow2"
      file_name          = "rocky9-genericcloud-amd64-20251123.qcow2"
      checksum           = "15d81d3434b298142b2fdd8fb54aef2662684db5c082cc191c3c79762ed6360c"
      checksum_algorithm = "sha256"
    }
  }

  # https://gitlab.archlinux.org/archlinux/infrastructure/-/blob/master/tf-stage1/archlinux.tf?ref_type=heads#L80
  machines = {
    "dns-powerdns-prod-01" = {
      tags                   = ["terraform", "dns"]
      started                = true
      protection             = true
      instance_type_provider = "aws"
      instance_type          = "c5.large"
      disk_import_from       = proxmox_virtual_environment_download_file.images["release_20251123_rocky_9_qcow2"].id
      ip_config_ipv4_address = "192.168.0.20/24"
      ip_config_ipv4_gateway = "192.168.0.1"

      extra_disks = []
    }
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
