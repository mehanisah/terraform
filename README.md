# Proxmox Instance Module

## Description
This module provisions virtual machines (VMs) in Proxmox 8 using the Telmate/proxmox 3.0.1-rc4 provider. 
It supports dynamic configuration of CPU, memory, disk, and networking.

## How to Provision VM In Development Server
$ terraform init
$ terraform plan -var-file="vars/dev/dev.tfvars" \
    -var "vault_server_ip"=${VAULT_SERVER_IP} \
    -var "proxmox_server_ip"=${PROXMOX_DEV_IP} \
    -var "environment"=dev \
    -var "vm_id=${VM_ID}" \
    -var "vm_name=${VM_NAME}" \
    -var "cloudinit_template=${CLOUD_INIT_TEMPLATE}" \
    -var "cores=${CPU_CORE}" \
    -var "memory=${MEMORY}" \
    -var "disk_size=${DISK}" \
    -var "net_bridge=${NET_BRIDGE}" \
    -var "ip_address=${IP_ADDRESS}" \
    -var "gateway=${GATEWAY}" \
    -var "nameservers=${NAMESERVERS}" \
    -var "ansible_password=${ANSIBLE_PASSWORD}"

$ terraform apply -auto-approve -var-file="vars/dev/dev.tfvars" \
  -var "vault_server_ip"=${VAULT_SERVER_IP} \
  -var "proxmox_server_ip"=${PROXMOX_DEV_IP} \
  -var "environment"=dev \
  -var "vm_id=${VM_ID}" \
  -var "vm_name=${VM_NAME}" \
  -var "cloudinit_template=${CLOUD_INIT_TEMPLATE}" \
  -var "cores=${CPU_CORE}" \
  -var "memory=${MEMORY}" \
  -var "disk_size=${DISK}" \
  -var "net_bridge=${NET_BRIDGE}" \
  -var "ip_address=${IP_ADDRESS}" \
  -var "gateway=${GATEWAY}" \
  -var "nameservers=${NAMESERVERS}" \
  -var "ansible_password=${ANSIBLE_PASSWORD}"


  ## How to Provision VM In Staging Server
$ terraform init
$ terraform plan -var-file="vars/stg/stg.tfvars" \
    -var "vault_server_ip"=${VAULT_SERVER_IP} \
    -var "proxmox_server_ip"=${PROXMOX_DEV_IP} \
    -var "environment"=stg \
    -var "vm_id=${VM_ID}" \
    -var "vm_name=${VM_NAME}" \
    -var "cloudinit_template=${CLOUD_INIT_TEMPLATE}" \
    -var "cores=${CPU_CORE}" \
    -var "memory=${MEMORY}" \
    -var "disk_size=${DISK}" \
    -var "net_bridge=${NET_BRIDGE}" \
    -var "ip_address=${IP_ADDRESS}" \
    -var "gateway=${GATEWAY}" \
    -var "nameservers=${NAMESERVERS}" \
    -var "ansible_password=${ANSIBLE_PASSWORD}"

$ terraform apply -auto-approve -var-file="vars/stg/stg.tfvars" \
  -var "vault_server_ip"=${VAULT_SERVER_IP} \
  -var "proxmox_server_ip"=${PROXMOX_DEV_IP} \
  -var "environment"=stg \
  -var "vm_id=${VM_ID}" \
  -var "vm_name=${VM_NAME}" \
  -var "cloudinit_template=${CLOUD_INIT_TEMPLATE}" \
  -var "cores=${CPU_CORE}" \
  -var "memory=${MEMORY}" \
  -var "disk_size=${DISK}" \
  -var "net_bridge=${NET_BRIDGE}" \
  -var "ip_address=${IP_ADDRESS}" \
  -var "gateway=${GATEWAY}" \
  -var "nameservers=${NAMESERVERS}" \
  -var "ansible_password=${ANSIBLE_PASSWORD}"
