# infrastructure-home

## Overview

This repository contains Infrastructure as Code (IaC) for a home server environment

- **LXD**: hypervisor for virtual machines and LXC
- **Terraform**: provisions VMs in Proxmox and manages DNS
- **cloud-init**: initial VM configuration on first boot
- **Ansible**: bootstraps services
- **SaltStack**: brings VM and service state in line with the desired configuration

## References

Best practices and architecture documentation

- AWS Well-Architected Framework `https://aws.amazon.com/architecture/well-architected/`
- Google Cloud Architecture Center `https://cloud.google.com/architecture`
- Microsoft Azure Architecture Center `https://learn.microsoft.com/en-us/azure/architecture/`
- Oracle Cloud Infrastructure Architecture Center `https://docs.oracle.com/en/solutions/oci-best-practices/`
- HashiCorp Well-Architected Framework `https://developer.hashicorp.com/well-architected-framework`
