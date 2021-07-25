win_updates:
  wua.uptodate:
    - software: True
    - drivers: True
    - skip_hidden: False
    - skip_mandatory: False
    - skip_reboot: False
    - categories:
        - Critical Updates
        - Definition Updates
        - Drivers
        - Feature Packs
        - Security Updates
        - Update Rollups
        - Updates
        - Update Rollups
        - Windows Defender
    - severities:
        - Critical
        - Important