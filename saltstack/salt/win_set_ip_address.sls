win_set_ip_address:
  network.managed:
    - name: Ethernet0
    - dns_proto: static
    - dns_servers:
      - 127.0.0.1
      - 1.1.1.1
    - ip_proto: static
    - ip_addrs:
      - 192.168.3.200/24
    - gateway: 192.168.3.1