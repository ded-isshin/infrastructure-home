common_packages:
  pkg.installed:
    - pkgs:
      {{ salt['pillar.get']('common_packages', []) | json }}
