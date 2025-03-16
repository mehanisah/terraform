network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: no
      addresses:
        - ${ipv4_address}/24
      gateway4: ${gateway}
      nameservers:
        addresses: [43.74.1.31, 146.215.29.37, 146.215.29.38]
