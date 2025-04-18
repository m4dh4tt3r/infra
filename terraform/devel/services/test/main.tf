terraform {
  backend "s3" {
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
    bucket         = "wonderland-tf-state"
    key            = "devel/services/test.tfstate"
    region         = "us-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~>0.8.3"
    }
  }
}

provider "libvirt" {
  uri = "qemu+ssh://m4dh4tt3r@10.0.0.71/session?keyfile=/Users/m4dh4tt3r/.ssh/id_rsa&no_verify=1"
}

provider "libvirt" {
  alias = "node1"
  uri   = "qemu+ssh://m4dh4tt3r@10.0.0.71/session?keyfile=/Users/m4dh4tt3r/.ssh/id_rsa&no_verify=1"
}

provider "libvirt" {
  alias = "node2"
  uri   = "qemu+ssh://m4dh4tt3r@10.0.0.72/session?keyfile=/Users/m4dh4tt3r/.ssh/id_rsa&no_verify=1"
}

provider "libvirt" {
  alias = "node3"
  uri   = "qemu+ssh://m4dh4tt3r@10.0.0.73/session?keyfile=/Users/m4dh4tt3r/.ssh/id_rsa&no_verify=1"
}

provider "libvirt" {
  alias = "node4"
  uri   = "qemu+ssh://m4dh4tt3r@10.0.0.74/session?keyfile=/Users/m4dh4tt3r/.ssh/id_rsa&no_verify=1"
}
