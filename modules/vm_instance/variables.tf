variable "proxmox_server_host" {
  type = string
}

variable "vm_count" {
  description = "Number of VMs to create."
  type        = number
}

variable "vm_id" {
  description = "VM ID for the instances."
  type        = number
}

variable "vm_name" {
  description = "Base name for the VM instances."
  type        = string
}

variable "target_node" {
  description = "Hostname for VM instances."
  type        = string
}

variable "cloudinit_template" {
  description = "Name of the Proxmox Cloud-Init template."
  type        = string
}

variable "cores" {
  description = "Number of CPU cores per VM."
  type        = number
}

variable "memory" {
  description = "Memory in MB per VM."
  type        = number
}

variable "disk_size" {
  description = "Disk size in GB."
  type        = number
}

variable "storage_backends" {
  description = "Storage backends of Proxmox."
  type        = string
}

variable "net_bridge" {
  description = "Network bridge for the VM."
  type        = string
}

variable "ipv4_address" {
  description = "VM's IPv4 address."
  type        = string
}


variable "gateway" {
  description = "Gateway for the VMs."
  type        = string
}

variable "nameservers" {
  description = "List of DNS servers"
  type        = list(string)
  default     = ["160.33.96.81", "146.215.29.37", "146.215.29.38"]
}

variable "ansible_password" {
  description = "Password for the ansible user in the VM."
  type        = string
}

