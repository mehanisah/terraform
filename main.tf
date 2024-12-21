terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

provider "vault" {
  address = "http://${var.vault_server_ip}:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "eac220a1-fe69-8742-28f6-71079c761f5b"
      secret_id = "16dbd679-3c7a-cb41-3878-173a0b23b2c0"
    }
  }
}

# Read Vault secret
# https://registry.terraform.io/browse/providers > choose 'Vault' > Documentation > Data Sources > vault_kv_secret_v2
data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "apitoken-terraform-${var.environment}" 
}

provider "proxmox" {
  pm_api_url          = "https://${var.proxmox_server_ip}:8006/api2/json"
  pm_api_token_id     = data.vault_kv_secret_v2.example.data["id"]
  pm_api_token_secret = data.vault_kv_secret_v2.example.data["secret"]
  pm_tls_insecure     = var.pm_tls_insecure
}

module "vm_instance" {
  source = "./modules/vm_instance"
  vm_count = 1
  vm_id = var.vm_id
  vm_name = var.vm_name
  target_node = var.target_node
  cloudinit_template = var.cloudinit_template
  cores = var.cores
  memory = var.memory
  disk_size = var.disk_size
  storage_backends = var.storage_backends
  net_bridge = var.net_bridge
  ipv4_address = var.ip_address
  gateway = var.gateway
  nameservers = var.nameservers
  ansible_password = var.ansible_password
}

