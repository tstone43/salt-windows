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
    - args:
      - DomainMode: {{ pillar['domain_mode']}}
      - DomainName: {{ pillar['domain_name']}}
      - DomainNetbiosName: {{ pillar['domain_netbios_name']}}
      - ForestMode: {{ pillar['forest_mode']}}
      - SafeModeAdministratorPassword: {{ pillar['safe_mode_admin_password']}} 
    - onchanges:
      - Install_DNS_Server_AD_DS_Roles