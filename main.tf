terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

provider "vault" {
  address = "https://${var.vault_server_host}:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "${var.vault_terraform_role_id}"
      secret_id = "${var.vault_terraform_secret_id}"
    }
  }
}

# Read Vault secret
# https://registry.terraform.io/browse/providers > choose 'Vault' > Documentation > Data Sources > vault_kv_secret_v2
data "vault_kv_secret_v2" "api_token" {
  mount = "kv"
  name  = "proxmox-${var.environment}" 
}

provider "proxmox" {
  pm_api_url          = "https://${var.proxmox_server_host}:8006/api2/json"
  pm_api_token_id     = data.vault_kv_secret_v2.api_token.data["id"]
  pm_api_token_secret = data.vault_kv_secret_v2.api_token.data["secret"]
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
  ansible_password = var.ansible_password
}

