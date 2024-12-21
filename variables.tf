variable "vault_server_ip" {
  type = string
}

variable "proxmox_server_ip" {
  type = string
}

variable "environment" {
  type        = string
}

variable "pm_tls_insecure" {
  type = bool
}

variable "vm_id" {
  type = number
}

variable "vm_name" {
  type = string
}

variable "target_node" {
  type = string
}

variable "cloudinit_template" {
  type = string
}

variable "cores" {
  description = "cpu core"
  type = number
  default = 1
}

variable "memory" {
  description = "memory (MiB)"
  type = number
  default = 1024
}

variable "disk_size" {
  description = "disk size (GB)"
  type = number
  default = 30
}

variable "storage_backends" {
  type = string
}

variable "net_bridge" {
  type = string
}

variable "ip_address" {
  type = string
}

variable "gateway" {
  type = string
}

variable "nameservers" {
  type = string
}

variable "ansible_password" {
  type = string
}

