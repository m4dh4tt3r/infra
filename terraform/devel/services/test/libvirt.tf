resource "libvirt_pool" "vm_pool" {
  provider = libvirt.node4
  name     = "vm_pool"
  type     = "dir"
  path     = "/mnt/nvme/qemu-images"
}

resource "libvirt_cloudinit_disk" "test_ci" {
  provider = libvirt.node4
  name     = "${var.test_name}-ci.iso"
  pool     = libvirt_pool.vm_pool.name

  user_data = templatefile("${path.module}/cloud_init.tpl", {
    hostname = var.test_name
    fqdn     = "${var.test_name}.${var.domain}"
  })

  meta_data = templatefile("${path.module}/meta_data.tpl", {
    hostname = var.test_name
  })

  network_config = templatefile("${path.module}/network_config.tpl", {
    interface = var.interface
  })
}

resource "libvirt_volume" "test_ubuntu2204-qcow2" {
  provider = libvirt.node4
  name     = "ubuntu2204-${var.test_name}.qcow2"
  pool     = libvirt_pool.vm_pool.name
  source   = "https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-arm64.img"
  format   = "qcow2"
}

resource "libvirt_network" "test_net" {
  provider  = libvirt.node4
  name      = "test_net"
  mode      = "nat"
  domain    = var.domain
  addresses = ["192.168.122.0/24"]
  autostart = true

  dhcp {
    enabled = true
  }

  dns {
    enabled = true
  }
}

resource "libvirt_domain" "test_vm" {
  provider = libvirt.node4
  name     = var.test_name
  arch     = "aarch64"
  machine  = "virt"
  cpu {
    mode = "host-passthrough"
  }
  memory     = var.test_mem
  vcpu       = var.test_vcpu
  qemu_agent = false

  cloudinit = libvirt_cloudinit_disk.test_ci.id
  xml {
    xslt = file("${path.module}/transforms.xsl")
  }


  network_interface {
    network_id     = libvirt_network.test_net.id
  }

  disk {
    volume_id = libvirt_volume.test_ubuntu2204-qcow2.id
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
    autoport    = true
  }
}
