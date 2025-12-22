admin_packages_ubuntu22:
  pkg.installed:
    - pkgs:
      {{ salt['pillar.get']('admin:packages:ubuntu22', []) | json }}
