#!/bin/bash

# Usage: ./cloud-init-template.sh <VM_ID> <STORAGE_POOL>
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <VM_ID> <STORAGE_POOL>"
  echo "example: ./cloud-init-ubuntu-2204.sh 10000 local-lvm"
  exit 1
fi

# Arguments
VM_ID=$1
STORAGE_POOL=$2

# Add non-subscription Proxmox repository
echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list

# Update/upgrade system packages
apt update
if [ $? -ne 0 ]; then
    echo "Error: Download cloudimg failed. Exiting."
    #exit 1
fi

# Install libguestfs-tools
apt install -y libguestfs-tools
if [ $? -ne 0 ]; then
    echo "Error: Install libguestfs-tools failed. Exiting."
    exit 1
fi

wget https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-amd64.img
if [ $? -ne 0 ]; then
    echo "Error: Download cloudimg failed. Exiting."
    exit 1
fi

mv ubuntu-22.04-server-cloudimg-amd64.img ubuntu-22.04.qcow2
if [ $? -ne 0 ]; then
    echo "Error: Change filename failed. Exiting."
    exit 1
fi

virt-customize -a ubuntu-22.04.qcow2 --install qemu-guest-agent
if [ $? -ne 0 ]; then
    echo "Error: Install qemu guest agent on the image failed. Exiting."
    exit 1
fi

qm create $VM_ID --name "ubuntu-2204-cloudinit-template" --memory 1024 --cores 1 --net0 virtio,bridge=vmbr0
if [ $? -ne 0 ]; then
    echo "Error: Set template config file failed. Exiting."
    exit 1
fi

qm importdisk $VM_ID ubuntu-22.04.qcow2 $STORAGE_POOL
if [ $? -ne 0 ]; then
    echo "Error: Install qemu guest agent on the image failed. Exiting."
    exit 1
fi

# Configure the VM
qm set $VM_ID --scsihw virtio-scsi-pci --scsi0 ${STORAGE_POOL}:vm-${VM_ID}-disk-0
if [ $? -ne 0 ]; then
    echo "Error: Set scsihw failed. Exiting."
    exit 1
fi

qm set $VM_ID --boot c --bootdisk scsi0
if [ $? -ne 0 ]; then
    echo "Error: Set bootdisk failed. Exiting."
    exit 1
fi

qm set $VM_ID --ide0 ${STORAGE_POOL}:cloudinit
if [ $? -ne 0 ]; then
    echo "Error: Attach cloud-init drive to vm failed. Exiting."
    exit 1
fi

qm set $VM_ID --serial0 socket --vga std
if [ $? -ne 0 ]; then
    echo "Error: Set hardware vga. Exiting."
    exit 1
fi

qm set $VM_ID --agent enabled=1
if [ $? -ne 0 ]; then
    echo "Error: Install agent enable failed. Exiting."
    exit 1
fi

qm template $VM_ID
if [ $? -ne 0 ]; then
    echo "Error: Set vm as template failed. Exiting."
    exit 1
fi
