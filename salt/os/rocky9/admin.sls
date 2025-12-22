include:
  - os.rocky9.epel

admin_packages_rocky9:
  pkg.installed:
    - pkgs:
      {{ salt['pillar.get']('admin:packages:rocky9', []) | json }}
    - require:
      - pkg: epel-release
