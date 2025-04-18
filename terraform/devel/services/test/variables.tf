variable "img_path" {
  description = "Path to the base image"
  type        = string
  default     = "/var/lib/libvirt/images/ubuntu-22.04.qcow2"
}

variable "interface" {
  description = "Ethernet interface name"
  type        = string
  default     = "eth0"
}

variable "domain" {
  description = "Domain name"
  type        = string
  default     = "wonderland.local"
}

variable "qemu_node_ips" {
  description = "QEMU node IPs"
  type        = list(string)
  default = [
    "10.0.0.71",
    "10.0.0.72",
    "10.0.0.73",
    "10.0.0.74",
  ]
}

variable "username" {
  description = "QEMU node username"
  type        = string
  default     = "m4dh4tt3r"
}

variable "test_name" {
  description = "Test node"
  type        = string
  default     = "test_vm"
}

variable "test_vcpu" {
  description = "Test node CPUs"
  type        = number
  default     = 1
}

variable "test_mem" {
  description = "Test node memory"
  type        = string
  default     = "1024"
}
