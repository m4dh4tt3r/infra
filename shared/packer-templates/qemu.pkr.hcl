packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

variable "ubuntu_version" {
  description = "Ubuntu version"
  type        = string
  default     = "noble"
}

variable "image_url" {
  description = "QEMU image URL"
  type        = string
  default     = "https://github.com/Joshua-Riek/ubuntu-rockchip/releases/download/v2.4.0/ubuntu-24.04-preinstalled-server-arm64-turing-rk1.img.xz"
}

variable "qemu_arm64_exec" {
  description = "QEMU ARM64 executable path"
  type        = string
  default     = "/opt/homebrew/bin/qemu-system-aarch64"
}

variable "qemu_format" {
  description = "QEMU image format"
  type        = string
  default     = "qcow2"
}

variable "qemu_firmware" {
  description = "QEMU firmware path"
  type        = string
  default     = "/opt/homebrew/share/qemu/edk2-aarch64-code.fd"
}

variable "qemu_accel" {
  description = "QEMU accelerator"
  type        = string
  default     = "hvf"
}

variable "qemu_cpu_type" {
  description = "QEMU CPU type"
  type        = string
  default     = "max"
}

variable "disk_size" {
  description = "Root disk image size"
  type        = string
  default     = "20480"
}

source "qemu" "ubuntu-arm64" {
  name             = "ubuntu-${var.ubuntu_version}-cis-arm64"
  iso_url          = var.image_url
  iso_checksum     = "auto"
  output_directory = "output/${var.ubuntu_version}-cis-arm64"
  format           = var.qemu_format
  disk_size        = var.disk_size
  accelerator      = var.qemu_accel
  headless         = true
  boot_wait        = "10s"
  qemu_binary      = var.qemu_arm64_exec
  machine_type     = "virt"
  cpu              = var.qemu_cpu_type
  firmware         = var.qemu_firmware
  qemuargs = [
    ["-machine", "type=virt"],
    ["-cpu", var.qemu_cpu_type],
    ["-m", "2048"],
    ["-smp", "2"],
    ["-nographic"],
    ["-bios", var.qemu_firmware]
  ]
  boot_command = [
    "<esc><wait>",
    "linux autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ --- <enter>"
  ]
  http_directory   = "../http"
  communicator     = "ssh"
  ssh_username     = "ubuntu"
  ssh_password     = "packer"
  ssh_timeout      = "30m"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
}

build {
  sources = ["source.qemu.ubuntu-arm64"]

  provisioner "ansilbe" {
    playbook_file = "../ansible/playbooks/harden.yaml"
  }
}
