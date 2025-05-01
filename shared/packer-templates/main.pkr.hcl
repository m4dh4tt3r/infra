packer {
  required_version = ">= 1.7.0"
  required_plugins {
    ansible = {
      version = ">= 1.0.2"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

locals {
  timestamp = "${formatdate("YYYY-MM-DD-hhmmss", timestamp())}"
}
