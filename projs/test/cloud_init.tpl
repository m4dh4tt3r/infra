#cloud-config
chpasswd:
  list: |
    root:root
    m4dh4tt3r:m4dh4tt3r

users:
  - name: m4dh4tt3r
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ${file("~/.ssh/id_ecdsa.pub")}
    shell: /bin/bash
    groups: sudo

fqdn: "${fqdn}"
hostname: "${hostname}"

package_update: true
package_upgrade: true
