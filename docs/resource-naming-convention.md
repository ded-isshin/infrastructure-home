# Resource naming convention

## Hostname and DNS

### Rules

- Use lowercase only
- Allowed characters: `a-z`, `0-9`, `-`
- Do not start or end with `-`
- Use `-` as the only separator between components
- Keep each DNS label length <= 63 characters
- Keep the full FQDN length <= 255 characters
- Do not reuse an existing hostname for a different machine

### Template

| Naming component | Description |
|--|--|
| **Resource type** | An [abbreviation](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations) that represents the type of resource or asset |
| **Workload, application, or project** | Name of a workload, application, or project that the resource is a part of |
| **Environment** | Production, development |
| **Instance number** | The instance count for a specific resource, to differentiate it from other resources that have the same naming convention and naming components (2 digits) |

The separator `-` is used between components

### Examples

1. lbi-nginx-prod-01
2. db-postgresql-prod-03
3. master-kubernetes-dev-10
4. worker-kubernetes-dev-12
5. git-gitlab-prod-01
6. pve-hypervisor-prod-01

## References

1. `https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming`
2. `https://datatracker.ietf.org/doc/html/rfc1035`
