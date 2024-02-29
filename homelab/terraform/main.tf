# File: main.tf

resource "proxmox_vm_qemu" "vm" {
  name        = "testvm2"
  target_node = "prox"
  
  iso          = "local:iso/ubuntu-22.04.3-live-server-amd64.iso"  # Replace with your ISO path

  os_type      = "unmanaged"  # Use 'unmanaged' for ISO

  bios           = "ovmf" # UEFI BIOS
  machine        = "q35" # Machine type

# Add PCI device
  hostpci {
    host = "0000:00:17.0"
    pcie = 0
    rombar = 0
  }

  disk {
    type         = "scsi"
    storage      = "local-lvm"
    size         = "10G"
  }

  network {
    model     = "virtio"
    bridge    = "vmbr0"
    tag       = 100 # VLAN 100
  }

  memory  = 2048
  sockets = 1
  cores   = 1

}
