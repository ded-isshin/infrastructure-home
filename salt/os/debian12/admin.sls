admin_packages_debian12:
  pkg.installed:
    - pkgs: {{ salt['pillar.get']('admin:packages:debian12', []) }}
