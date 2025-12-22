common_packages:
  pkg.installed:
    - pkgs:
      {{ salt['pillar.get']('base:common_packages') | json }}
