enable_ping:
  cmd.run:
    - name: netsh advfirewall firewall set rule name="File and Printer Sharing (Echo Request - ICMPv4-In)" new enable=yes

open_ports_rdp:
  win_firewall.add_rule:
    - name: Remote Desktop
    - localport: 3389
    - protocol: tcp
    - action: allow