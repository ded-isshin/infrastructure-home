base:
  '*':
    - base.common

  'osfinger:Rocky Linux-9*':
    - match: grain
    - os.rocky9.epel
    - os.rocky9.admin

  'osfinger:Debian-12*':
    - match: grain
    - os.debian12.admin

  'osfinger:Debian-13*':
    - match: grain
    - os.debian13.admin

  'osfinger:Ubuntu-22*':
    - match: grain
    - os.ubuntu22.admin

  'osfinger:Ubuntu-24*':
    - match: grain
    - os.ubuntu24.admin
