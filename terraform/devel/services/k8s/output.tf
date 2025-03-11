output "k8s_ctlr_ip" {
  value = libvirt_domain.k8s_ctlr.*.network_interface.0.addresses
}

output "k8s_wrkr_ip" {
  value = libvirt_domain.k8s_wrkr.*.network_interface.0.addresses
}
