resource "proxmox_vm_qemu" "proxmox" {

count = var.instance_count

name = element(var.name,count.index)

target_node = var.target_node

clone = var.clone

#cpu

cores = 1

sockets = 1

cpu = "host"

#memory

memory = "2048"

#network

network {

bridge = element(var.network_bridge,count.index)

model = "virtio"

}

ipconfig0 = element(var.ip,count.index)

nameserver = var.server_dns

#disk

scsihw = "virtio-scsi-pci"

cloudinit_cdrom_storage = var.storage

disks {

virtio {

virtio0 {

disk {

size = var.size

storage = var.storage

iothread = true

}

}

}

}

#cloud init config

os_type = "cloud-init"

ciuser = var.ciuser

cipassword = var.cipwd

sshkeys = <<EOF

${var.ssh_key}

EOF

}
