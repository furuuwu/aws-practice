packer {
  required_plugins {
    amazon = {
      version = "~> 1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

variable "my_region" {
  type    = string
  default = "eu-west-1"
}

variable "my_instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro" # what is available or is free tier depends on the machine
}

variable "my_script" {
  type    = string
  default = "setup.sh"
}

variable "my_app" {
  type    = string
  default = "my_app"
}


# most of these should be variables tbh but unsure of how to go about it
# https://developer.hashicorp.com/packer/integrations/hashicorp/amazon
source "amazon-ebs" "app" {
  ami_name      = "app-${local.timestamp}"
  instance_type = var.my_instance_type
  region        = var.my_region

  source_ami_filter {
    filters = {
      # name = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      name                = "al2023-ami-*-kernel-6.1-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  # ssh_username = "ubuntu"
  ssh_username = "ec2-user"
}
# example free tier
# ami id: ami-04fe22dfadec6f0b6
# from that you get
# ami name: al2023-ami-2023.4.20240528.0-kernel-6.1-x86_64
# owner (alias): amazon


build {
  sources = ["source.amazon-ebs.app"]

  /*
  provisioner "file" {
    source      = "../tf-packer.pub"
    destination = "/tmp/tf-packer.pub"
  }
  */

  provisioner "file" {
    source      = "../app/app.zip"
    destination = "/home/ec2-user/app.zip"
  }

  provisioner "file" {
    source      = "../app/app.service"
    destination = "/tmp/app.service"
  }

  provisioner "shell" {
    script = "../scripts/setup_amazon_linux_node.sh"
  }
}