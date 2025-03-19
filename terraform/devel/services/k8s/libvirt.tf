resource "libvirt_cloudinit_disk" "k8s_ctlr_init" {
  count = length(var.k8s_ctlr_name)
  name  = "${var.k8s_ctlr_name[count.index]}-init.iso"
  user_data = templatefile("${path.module}/cloud_init.cfg", {
    hostname = var.k8s_ctlr_name[count.index]
    fqdm     = "${var.k8s_ctlr_name[count.index]}.${var.domain}"
  })
  network_config = templatefile("${path.module}/network_config.cfg", {
    interface = var.interface
    ip_addr   = var.k8s_ctlr_ips[count.index]
  })
}

resource "libvirt_volume" "k8s_ctlr_ubuntu2204-qcow2" {
  count  = length(var.k8s_ctlr_name)
  name   = "ubuntu2204-qcow2.${var.k8s_ctlr_name[count.index]}"
  pool   = "kubernetes"
  source = var.img_path
  format = "qcow2"
}

resource "libvirt_domain" "k8s_ctlr" {
  count      = length(var.k8s_ctlr_name)
  name       = var.k8s_ctlr_name[count.index]
  memory     = var.k8s_ctlr_mem
  vcpu       = var.k8s_ctlr_vcpu
  qemu_agent = "true"

  network_interface {
    network_name = "kubernetes"
    addresses    = [var.k8s_ctlr_ips[count.index]]
  }

  disk {
    volume_id = element(libvirt_volume.k8s_ctlr_ubuntu2204-qcow2.*.id, count.index)
  }

  cloudinit = libvirt_cloudinit_disk.k8s_ctlr_init[count.index].id

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

resource "libvirt_cloudinit_disk" "k8s_wrkr_init" {
  count = length(var.k8s_wrkr_name)
  name  = "${var.k8s_wrkr_name[count.index]}-init.iso"

  user_data = templatefile("${path.module}/cloud_init.cfg", {
    hostname = var.k8s_wrkr_name[count.index]
    fqdm     = "${var.k8s_wrkr_name[count.index]}.${var.domain}"
  })

  meta_data = templatefile("${path.module}/meta_data.cfg", {
    hostname = var.k8s_wrkr_name[count.index]
  })

  network_config = templatefile("${path.module}/network_config.cfg", {
    interface = var.interface
    ip_addr   = var.k8s_wrkr_ips[count.index]
  })
}

resource "libvirt_volume" "k8s_wrkr_ubuntu2204-qcow2" {
  count  = length(var.k8s_wrkr_name)
  name   = "ubuntu2204-qc0w2.${var.k8s_wrkr_name[count.index]}"
  pool   = "kubernetes"
  source = var.img_path
  format = "qcow2"
}

resource "libvirt_domain" "k8s_wrkr" {
  count      = length(var.k8s_wrkr_name)
  name       = var.k8s_wrkr_name[count.index]
  memory     = var.k8s_wrkr_mem
  vcpu       = var.k8s_wrkr_vcpu
  qemu_agent = "true"

  network_interface {
    network_name = "kubernetes"
    addresses    = [var.k8s_wrkr_ips[count.index]]
  }

  disk {
    volume_id = element(libvirt_volume.k8s_wrkr_ubuntu2204-qcow2.*.id, count.index)
  }

  cloudinit = libvirt_cloudinit_disk.k8s_wrkr_init[count.index].id

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
