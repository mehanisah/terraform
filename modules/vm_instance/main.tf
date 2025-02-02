terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

resource "proxmox_vm_qemu" "vm_instance" {
  count       = var.vm_count
  vmid        = var.vm_id
  name        = "${var.vm_name}"
  target_node = var.target_node
  clone       = var.cloudinit_template
  agent       = 1
  os_type     = "ubuntu"
  cores       = var.cores
  sockets     = 1
  cpu         = "host"
  memory      = var.memory
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  ciuser      = "ansible"
  cipassword  = var.ansible_password
  sshkeys     = <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCT/Q/Vm4JoGRz9aQhJOoVXy+4QXXDxEK5pR2xfFpp1cEJjkqVP1iA+AqvP3cNlwMuKYFZOpFX2FacvocGYyp0KgHN9fDZUue6xhNhjcBJSsq9u5xAOi8mE4Ttb9ywspP1Kb96ErUCMpj/OGu76M8/aU5Yv2DGafm+67Ztnu4L61DpgWawm3K84qat9GEjTicNIU/LnRPznjES3YZItw9ifMBLWogfNkM/VE1xrccI8tQYvRQo/jj9ox++EDQMak8utZPDwqukSzN+RElWo1SpMzxGv7caeougPr1kde3tbi5dSmZ1Ldic1lUZAZWI2CiTvoH6FQAiIISDtmPSGBhBv ansible-ssh
    EOF

  disk {
    slot    = "scsi0"
    size    = var.disk_size
    type    = "disk"
    storage = var.storage_backends
  }

  # Cloud-Init Drive
  disk {
    slot    = "ide0"
    type    = "cloudinit"
    storage = var.storage_backends
  }

  network {
    model  = "virtio"
    bridge = var.net_bridge
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  onboot = true

 # static ip address assignment increasing 
 ipconfig0 = "ip=${var.ipv4_address}/24,gw=${var.gateway}"
 nameserver = var.nameservers

  connection {
    type = "ssh"
    user = "ansible"
    private_key = file("/root/.ssh/ansible") 
    host = "${var.ipv4_address}"
    port = 22
}

provisioner "remote-exec" {
    inline = [
        "sudo mv /etc/netplan/50-cloud-init.yaml /etc/netplan/01-netcfg.yaml",
        "sudo apt update",
        "sudo apt install -y apt-transport-https ca-certificates curl software-properties-common",
        "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
        "echo \"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
        "sudo apt update",
        "sudo apt install -y docker-ce docker-ce-cli containerd.io",
        "sudo usermod -aG docker ansible"
        "sudo apt install -y nfs-common"
    ]
}


}
