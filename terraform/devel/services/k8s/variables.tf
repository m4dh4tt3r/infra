variable "img_path" {
  description = "Path to the base image"
  type        = string
}

variable "interface" {
  description = "Ethernet interface name"
  type        = string
  default     = "ens3"
}

variable "domain" {
  description = "Domain name"
  type        = string
  default     = "wonderland.local"
}

variable "k8s_ctlr_name" {
  description = "Kubernetes controller node name"
  type        = list(string)
  default     = ["k8s-ctlr1", "k8s-ctlr2", "k8s-ctlr3"]
}

variable "k8s_ctlr_vcpu" {
  description = "Kubernetes controller CPUs"
  type        = number
  default     = 1
}

variable "k8s_ctlr_mem" {
  description = "Kubernets controller memory"
  type        = string
  default     = "1024"
}

variable "k8s_ctlr_ips" {
  description = "Kubernetes controller IP addresses"
  type        = list(string)
}

variable "k8s_wrkr_name" {
  description = "Kubernetes worker node name"
  type        = list(string)
  default     = ["k8s-wrkr1", "k8s-wrkr2", "k8s-wrkr3", "k8s-wrkr4", "k8s-wrkr5", "k8s-wrkr6", "k8s-wrkr7"]
}

variable "k8s_wrkr_vcpu" {
  description = "Kubernetes worker CPUs"
  type        = number
  default     = 4
}

variable "k8s_wrkr_mem" {
  description = "Kubernets worker memory"
  type        = string
  default     = "4096"
}

variable "k8s_wrkr_ips" {
  description = "Kubernetes worker IP addresses"
  type        = list(string)
}
