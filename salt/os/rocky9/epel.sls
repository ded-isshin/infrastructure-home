crb_repo_enabled:
  ini.options_present:
    - name: /etc/yum.repos.d/rocky.repo
    - sections:
        crb:
          enabled: 1

dnf_clean_all_after_repo_change:
  cmd.run:
    - name: dnf -y clean all
    - onchanges:
      - ini: crb_repo_enabled

epel-release:
  pkg.installed:
    - require:
      - ini: crb_repo_enabled
