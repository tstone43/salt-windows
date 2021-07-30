Install_DNS_Server_AD_Domain_Services_Roles:
  win_servermanager.installed:
    - recurse: True
    - features:
      - DNS
      - AD-Domain-Services
    - restart: True
