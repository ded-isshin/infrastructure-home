# Infrastructure Constraints and Architectural Decisions

## Overview

This document describes the architectural decisions, constraints, and trade-offs made in the infrastructure setup. It explains why certain technologies were chosen over alternatives and what limitations exist in the current setup.

## Table of Contents

1. [Hypervisor: LXD vs Proxmox](#hypervisor-lxd-vs-proxmox)
2. [GitLab Installation: Omnibus vs GitLab Environment Toolkit](#gitlab-installation-omnibus-vs-gitlab-environment-toolkit)

---

## Decision: Migrated from Proxmox to LXD

1. **Disk recreation problem with `import_from` parameter** - Issue described in [GitHub Issue #2119](https://github.com/bpg/terraform-provider-proxmox/issues/2119), persisted in provider version `bpg/proxmox = 0.89.1`
2. **Proxmox itself** - Proxmox is enterprise-grade software, but it is poorly adapted for IaC and is better suited for more "traditional" usage patterns
3. **Community-supported providers** - Both `bpg/terraform-provider-proxmox` and `Telmate/terraform-provider-proxmox` are community-maintained with limited functionality and bugs (both providers are good efforts by the community, thanks to all contributors!)
4. **Frequent errors with concurrent Terraform operations** - Issues when running with default parallelism (10 concurrent operations)

---

## GitLab Installation: Omnibus vs GitLab Environment Toolkit

### Decision: GitLab Omnibus Installation

1. **GitLab Environment Toolkit (GET) limitations for on-premise** - GET is excellent automation, but it is better suited for cloud environments and has limitations for on-premise usage. See [Custom Servers On-Prem documentation](https://gitlab.com/gitlab-org/gitlab-environment-toolkit/-/blob/main/docs/environment_advanced.md#custom-servers-on-prem) and [5k static Ansible example](https://gitlab.com/gitlab-org/gitlab-environment-toolkit/-/tree/main/examples/5k_static/ansible)
2. **GitLab Omnibus is sufficient for most scenarios** - For most use cases, deploying GitLab Omnibus is sufficient, and migration to a more complex setup can be done later if needed
