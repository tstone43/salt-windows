include:
  - win_firewall

enable_rdp:
  rdp.enabled:
    - name: rdp.enable
    - require:
      - sls: win_firewall