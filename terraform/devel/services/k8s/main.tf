terraform {
  backend "s3" {
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
    bucket         = "wonderland-tf-state"
    key            = "devel/services/k8s.tfstate"
    region         = "us-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~>0.7.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu+ssh://kvm01.wonderland.local:53330/system"
}
