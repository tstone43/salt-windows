remove_ad_ds_dns:
  win_servermanager.removed:
    - features:
      - DNS
      - AD-Domain-Services
    - restart: True