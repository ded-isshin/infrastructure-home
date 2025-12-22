admin_packages_debian13:
  pkg.installed:
    - pkgs:
      {{ salt['pillar.get']('admin:packages:debian13', []) | json }}
