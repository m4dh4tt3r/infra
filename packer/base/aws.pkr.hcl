packer {
  required_version = ">= 1.7.0"
  required_plugins {
    amazon = {
      version = ">= 1.2.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_build_region" {
  description = "AWS region to build AMIs"
  type        = string
  default     = "us-east-1"
}

variable "aws_regions" {
  description = "AWS regions to copy AMIs"
  type        = list(string)
  default = [
    "us-east-1",
  ]
}

variable "aws_accounts" {
  description = "Accounts that can use AMIs"
  type        = list(string)
  default = [
    "894425743282"
  ]
}

data "amazon-ami" "focal-amd64" {
  filters = {
    virtualization-type = "hvm"
    name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server*"
    root-device-type    = "ebs"
  }
  owners      = ["099720109477"]
  most_recent = true
}

data "amazon-ami" "focal-arm64" {
  filters = {
    virtualization-type = "hvm"
    name                = "ubuntu/images/*ubuntu-focal-20.04-arm64-server*"
    root-device-type    = "ebs"
  }
  owners      = ["099720109477"]
  most_recent = true
}

data "amazon-ami" "jammy-amd64" {
  filters = {
    virtualization-type = "hvm"
    name                = "ubuntu/images/*ubuntu-focal-22.04-amd64-server*"
    root-device-type    = "ebs"
  }
  owners      = ["099720109477"]
  most_recent = true
}

data "amazon-ami" "jammy-arm64" {
  filters = {
    virtualization-type = "hvm"
    name                = "ubuntu/images/*ubuntu-focal-22.04-arm64-server*"
    root-device-type    = "ebs"
  }
  owners      = ["099720109477"]
  most_recent = true
}

source "amazon-ebs" "focal-amd64" {
  region          = var.aws_build_region
  source_ami      = data.amazon-ami.focal-amd64.id
  instance_type   = "t2.micro"
  ssh_username    = "ubuntu"
  ami_name        = "golden-ubuntu-2004-amd64_${local.timestamp}"
  ami_description = "Hardened base Ubuntu 20.04 amd64 golden image"
  deprecate_at    = timeadd(timestamp(), "8760h")
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
  // encrypt_boot = true
  ami_users   = var.aws_accounts
  ami_regions = var.aws_regions
  tags = {
    Name                = "Ubuntu 22.04 amd64 CIS"
    OS_Version          = "Ubuntu"
    Release             = "20.04"
    Architecture        = "amd64"
    Build_Region        = "{{ .BuildRegion }}"
    Base_AMI_ID         = "{{ .SourceAMI }}"
    Base_AMI_Name       = "{{ .SourceAMIName }}"
    Base_AMI_Owner_Name = "{{ .SourceAMIOwnerName }}"
  }
}

source "amazon-ebs" "focal-arm64" {
  region          = var.aws_build_region
  source_ami      = data.amazon-ami.focal-arm64.id
  instance_type   = "a1.large"
  ssh_username    = "ubuntu"
  ami_name        = "golden-ubuntu-2004-arm64_${local.timestamp}"
  ami_description = "Hardened base Ubuntu 20.04 arm64 golden image"
  deprecate_at    = timeadd(timestamp(), "8760h")
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
  // encrypt_boot = true
  ami_users   = var.aws_accounts
  ami_regions = var.aws_regions
  tags = {
    Name                = "Ubuntu 20.04 arm64 CIS"
    OS_Version          = "Ubuntu"
    Release             = "20.04"
    Architecture        = "arm64"
    Build_Region        = "{{ .BuildRegion }}"
    Base_AMI_ID         = "{{ .SourceAMI }}"
    Base_AMI_Name       = "{{ .SourceAMIName }}"
    Base_AMI_Owner_Name = "{{ .SourceAMIOwnerName }}"
  }
}

source "amazon-ebs" "jammy-amd64" {
  region          = var.aws_build_region
  source_ami      = data.amazon-ami.jammy-amd64.id
  instance_type   = "t2.micro"
  ssh_username    = "ubuntu"
  ami_name        = "golden-ubuntu-2204-amd64_${local.timestamp}"
  ami_description = "Hardened base Ubuntu 22.04 amd64 golden image"
  deprecate_at    = timeadd(timestamp(), "8760h")
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
  // encrypt_boot = true
  ami_users   = var.aws_accounts
  ami_regions = var.aws_regions
  tags = {
    Name                = "Ubuntu 22.04 amd64 CIS"
    OS_Version          = "Ubuntu"
    Release             = "22.04"
    Architecture        = "amd64"
    Build_Region        = "{{ .BuildRegion }}"
    Base_AMI_ID         = "{{ .SourceAMI }}"
    Base_AMI_Name       = "{{ .SourceAMIName }}"
    Base_AMI_Owner_Name = "{{ .SourceAMIOwnerName }}"
  }
}

source "amazon-ebs" "jammy-arm64" {
  region          = var.aws_build_region
  source_ami      = data.amazon-ami.jammy-arm64.id
  instance_type   = "a1.large"
  ssh_username    = "ubuntu"
  ami_name        = "golden-ubuntu-2204-arm64_${local.timestamp}"
  ami_description = "Hardened base Ubuntu 22.04 arm64 golden image"
  deprecate_at    = timeadd(timestamp(), "8760h")
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
  // encrypt_boot = true
  ami_users   = var.aws_accounts
  ami_regions = var.aws_regions
  tags = {
    Name                = "Ubuntu 22.04 arm64 CIS"
    OS_Version          = "Ubuntu"
    Release             = "22.04"
    Architecture        = "arm64"
    Build_Region        = "{{ .BuildRegion }}"
    Base_AMI_ID         = "{{ .SourceAMI }}"
    Base_AMI_Name       = "{{ .SourceAMIName }}"
    Base_AMI_Owner_Name = "{{ .SourceAMIOwnerName }}"
  }
}

build {
  sources = [
    "source.amazon-ebs.focal-amd64",
    "source.amazon-ebs.focal-arm64",
    "source.amazon-ebs.jammy-amd64",
    "source.amazon-ebs.jammy-arm64",
  ]
}
