admin_packages_ubuntu24:
  pkg.installed:
    - pkgs:
      {{ salt['pillar.get']('admin:packages:ubuntu24') | json }}
