terraform {
  required_providers {
    lxd = {
      source  = "terraform-lxd/lxd"
      version = ">= 2.6.1"
    }
    powerdns = {
      source  = "pan-net/powerdns"
      version = ">= 1.5.0"
    }
  }

  required_version = ">= 1.4"
}
