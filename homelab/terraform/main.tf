# File: main.tf

variable "lxc_root_password" {
  description = "The root password for the LXC container"
  type        = string
}

resource "proxmox_vm_qemu" "bak" {
  # VM Settings
  name              = "BAK"
  vmid              = 105
  target_node       = "prox"
  bios              = "ovmf"
  machine           = "q35"
  vm_state          = "running"
  full_clone        = false # Buggy program -.-

  # Boot
  onboot            = true
  automatic_reboot  = true
  startup           = "order=7"
  iso               = "local:iso/proxmox-backup-server_3.0-1.iso"

  # OS and Qemu Agent
  qemu_os           = "l26"
  os_type           = "6.x - 2.6 Kernel"
  agent             = 1

  # CPU
  sockets           = 1
  cores             = 2
  cpu               = "x86-64-v3"
  
  # RAM
  memory            = 4096

  # Disks
  scsihw = "virtio-scsi-pci"
  disks {
    scsi {
        scsi0 {
            disk {
                size = 32
                storage = "local-lvm"
            }
        }
    }
  }


  efidisk {
    efitype = "4m"
    storage = "local-lvm"
  }

  network {
    model     = "virtio"
    bridge    = "vmbr0"
    macaddr   = "00:0C:29:7B:40:A8"
    tag       = 100
  }

}


resource "proxmox_vm_qemu" "opn2" {
  # VM Settings
  name              = "OPN2"
  # vmid              = 105
  target_node       = "prox"
  bios              = "ovmf"
  machine           = "q35"
  vm_state          = "stopped"
  full_clone        = false # Buggy program -.-

  # Boot
  onboot            = true
  automatic_reboot  = true
  startup           = "order=7"
  iso               = "local:iso/proxmox-backup-server_3.0-1.iso"

  # OS and Qemu Agent
  qemu_os           = "l26"
  os_type           = "6.x - 2.6 Kernel"
  agent             = 1

  # CPU
  sockets           = 1
  cores             = 2
  cpu               = "x86-64-v3"
  
  # RAM
  memory            = 4096

  # Disks
  scsihw = "virtio-scsi-pci"
  disks {
    scsi {
        scsi0 {
            disk {
                size = 32
                storage = "local-lvm"
            }
        }
    }
  }


  efidisk {
    efitype = "4m"
    storage = "local-lvm"
  }

  network {
    model     = "virtio"
    bridge    = "vmbr0"
    # macaddr   = "00:0C:29:7B:40:A8"
    # tag       = 100
  }

}


resource "proxmox_vm_qemu" "home" {
  # VM Settings
  name              = "HOME"
  vmid              = 103
  target_node       = "prox"
  bios              = "ovmf"
  machine           = "q35"
  vm_state          = "running"
  full_clone        = false # Buggy program -.-
  define_connection_info = false # Buggy program -.-

  # Boot
  onboot            = true
  automatic_reboot  = true
  boot              = "order=sata0"
  startup           = "order=2"

  # OS and Qemu Agent
  qemu_os           = "l26"
  os_type           = "6.x - 2.6 Kernel"
  agent             = 1

  # CPU
  sockets           = 1
  cores             = 2
  cpu               = "x86-64-v3"
  
  # RAM
  memory            = 8192

  # Disks
  scsihw = "virtio-scsi-pci"
  disks {
    sata {
        sata0 {
            disk {
                size = 50
                storage = "local-lvm"
                replicate = true
            }
        }
    }
  }

  # efidisk {
  #   efitype = "4m"
  #   storage = "local-lvm"
  # }

  smbios {
  uuid = "dc8d4522-6b29-4c30-bf0e-3c553ddc627e"
}
  network {
    model     = "virtio"
    bridge    = "vmbr0"
    macaddr   = "02:17:c7:1f:a3:06"
    tag       = 150
  }

  hostpci {
    host = "0000:00:14.0"
    pcie = 1
    rombar = 1
  }

}

resource "proxmox_vm_qemu" "opn" {
  # VM Settings
  name              = "OPN"
  vmid              = 101
  target_node       = "prox"
  bios              = "seabios"
  machine           = "q35"
  vm_state          = "running"
  full_clone        = false # Buggy program -.-
  define_connection_info = false # Buggy program -.-

  # Boot
  onboot            = true
  automatic_reboot  = false
  boot              = "order=scsi0"
  startup           = "order=1"

  # OS and Qemu Agent
  qemu_os           = "other"
  os_type           = "other"
  agent             = 1

  # CPU
  sockets           = 1
  cores             = 2
  cpu               = "x86-64-v3"
  
  # RAM
  memory            = 4096

  # Disks
  scsihw = "lsi"
  disks {
    scsi {
        scsi0 {
            disk {
                size = 40
                storage = "local-lvm"
                replicate = true
            }
        }
    }
  }

  smbios {
    uuid = "03bb99f0-6f7a-46ae-9e18-a9a942d9d207"
  }

  network {
    model     = "virtio"
    bridge    = "vmbr0"
    macaddr   = "7A:54:1E:49:21:20"
    tag       = null
  }

}

resource "proxmox_vm_qemu" "nas" {
  # VM Settings
  name              = "NAS"
  vmid              = 102
  target_node       = "prox"
  bios              = "seabios"
  machine           = "q35"
  vm_state          = "running"
  full_clone        = false # Buggy program -.-
  define_connection_info = false # Buggy program -.-

  # Boot
  onboot            = true
  automatic_reboot  = true
  boot              = "order=scsi1"
  startup           = "order=2"

  # OS and Qemu Agent
  qemu_os           = "l26"
  os_type           = "6.x - 2.6 Kernel"
  agent             = 1

  # CPU
  sockets           = 1
  cores             = 2
  cpu               = "x86-64-v3"
  
  # RAM
  memory            = 14336

  # Disks
  scsihw = "lsi"
  disks {
    scsi {
        scsi1 {
            disk {
                size = 85
                storage = "local-lvm"
                replicate = true
            }
        }
    }
  }

  smbios {
    uuid = "bf5fd79a-6c4d-4f56-9e74-68e771408691"
  }

  network {
    model     = "virtio"
    bridge    = "vmbr0"
    macaddr   = "00:0C:29:47:54:37"
    tag       = 100
  }

    hostpci {
    host = "0000:00:17.0"
    pcie = 1
    rombar = 1
  }

}

resource "proxmox_vm_qemu" "dmz" {
  # VM Settings
  name              = "DMZ"
  vmid              = 107
  target_node       = "prox"
  bios              = "ovmf"
  machine           = "q35"
  vm_state          = "running"
  full_clone        = false # Buggy program -.-
  define_connection_info = false # Buggy program -.-

  # Boot
  onboot            = true
  automatic_reboot  = true
  boot              = "order=scsi0"
  startup           = "order=3"

  # OS and Qemu Agent
  qemu_os           = "l26"
  os_type           = "6.x - 2.6 Kernel"
  agent             = 1

  # CPU
  sockets           = 1
  cores             = 2
  cpu               = "x86-64-v3"
  
  # RAM
  memory            = 16384
  balloon           = 4096

  # Disks
  scsihw = "virtio-scsi-single"
  disks {
    scsi {
        scsi0 {
            disk {
                size = 90
                storage = "local-lvm"
                replicate = true
            }
        }
    }
  }

  smbios {
    uuid = "8c46291c-a1f6-4529-946b-a35329cf9b86"
  }

  efidisk {
    efitype = "4m"
    storage = "local-lvm"
  }
  network {
    model     = "virtio"
    bridge    = "vmbr0"
    macaddr   = "BC:24:11:71:CB:B5"
    tag       = 200
  }

}

resource "proxmox_lxc" "dns" {
  # VM Settings
  hostname          = "DNS"
  vmid              = 100
  target_node       = "prox"
  description       = "# Adguard LXC\n  ### https://tteck.github.io/Proxmox/\n  \u003ca href='https://ko-fi.com/D1D7EP4GF'\u003e\u003cimg src='https://img.shields.io/badge/☕-Buy me a coffee-red' /\u003e\u003c/a\u003e\n"
  tags = " " # Buggy program -.-
  
  # Container Settings
  unprivileged      = true
  ostemplate        = "local:vztmpl/debian-12-standard_12.0-1_amd64.tar.zst"
  password          = var.lxc_root_password
  
  # Boot
  onboot            = true
  start             = true
  startup           = "order=1"

  # OS and Qemu Agent
  ostype            = "debian"
  arch              = "amd64"

  # Console
  # cmode             = "/dev/console"
  console           = true
  tty               = 2

  features {
    nesting         = true
    keyctl          = true
  }

  # CPU
  cores             = 1
  
  # RAM
  memory            = 512
  swap              = 512

  # Disks
  rootfs {
    storage = "local-lvm"
    size    = "2G"
  }


  network {
    name      = "eth0"
    bridge    = "vmbr0"
    ip        = "dhcp"
    hwaddr    = "AA:52:08:43:F8:DE"
    tag       = 100
  }

}

resource "proxmox_lxc" "dns2" {
  # VM Settings
  hostname          = "DNS2"
  vmid              = 106
  target_node       = "prox"
  description       = "# Adguard LXC\n  ### https://tteck.github.io/Proxmox/\n  \u003ca href='https://ko-fi.com/D1D7EP4GF'\u003e\u003cimg src='https://img.shields.io/badge/☕-Buy me a coffee-red' /\u003e\u003c/a\u003e\n"
  tags = " " # Buggy program -.-
  
  # Container Settings
  unprivileged      = true
  ostemplate        = "local:vztmpl/debian-12-standard_12.0-1_amd64.tar.zst"
  password          = var.lxc_root_password
  
  # Boot
  onboot            = true
  start             = true
  startup           = "order=1"

  # OS and Qemu Agent
  ostype            = "debian"
  arch              = "amd64"

  # Console
  # cmode             = "/dev/console"
  console           = true
  tty               = 2

  features {
    nesting         = true
    keyctl          = true
  }

  # CPU
  cores             = 1
  
  # RAM
  memory            = 512
  swap              = 512

  # Disks
  rootfs {
    storage = "local-lvm"
    size    = "2G"
  }


  network {
    name      = "eth0"
    bridge    = "vmbr0"
    ip        = "dhcp"
    hwaddr    = "DA:58:3F:84:FF:7E"
    tag       = 100
  }

}