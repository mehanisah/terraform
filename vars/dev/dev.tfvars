pm_api_url          = "https://${var.proxmox_server_host}:8006/api2/json"
pm_tls_insecure     = true
storage_backends    = "local-lvm"
target_node         = "pve" 
