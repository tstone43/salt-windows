rename_computer:
  system.hostname:
    - name: salt-dc01
reboot_computer:
  system.reboot:
    - in_seconds: 30
    - force_close: true
    - only_on_pending_reboot: true