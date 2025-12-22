dnf-plugins-core:
  pkg.installed:

enable_crb:
  cmd.run:
    - name: dnf -y config-manager --set-enabled crb
    - unless: dnf repolist --enabled | awk '{print $1}' | grep -qx crb
    - require:
      - pkg: dnf-plugins-core

epel-release:
  pkg.installed:
    - require:
      - cmd: enable_crb
