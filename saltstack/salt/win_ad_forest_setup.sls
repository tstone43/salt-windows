Install_DNS_Server_AD_DS_Roles:
  win_servermanager.installed:
    - recurse: True
    - features:
      - DNS
      - AD-Domain-Services
    - restart: True
Setup_AD_Forest:
  cmd.script:
    - source: salt://setup_ad_forest.ps1
    - shell: powershell
    - template: jinja
    - onchanges:
      - Install_DNS_Server_AD_DS_Roles