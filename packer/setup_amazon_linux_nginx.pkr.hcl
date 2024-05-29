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
  type = string
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

  # AMI Configuration - required

  ami_name = "app-${local.timestamp}"
  # The name of the resulting AMI that will appear when managing AMIs in the AWS console or via APIs. This must be unique. 
  # To help make this unique, use a function like timestamp 

  # AMI Configuration - optional

  # ami_regions ([]string) - A list of regions to copy the AMI to. Tags and attributes are copied along with the AMI. 
  # AMI copying takes time depending on the size of the AMI, but will generally take many minutes.

  # Access Configuration - required

  # access_key (string) - The access key used to communicate with AWS. Learn how to set this. 
  # On EBS, this is not required if you are using use_vault_aws_engine for authentication instead.

  # secret_key (string) - The secret key used to communicate with AWS. Learn how to set this. 
  # This is not required if you are using use_vault_aws_engine for authentication instead.

  region = var.my_region
  # The name of the region, such as us-east-1, in which to launch the EC2 instance to create the AMI. 
  # When chroot building, this value is guessed from environment.

  # Access Configuration - optional
  # pass

  # Assume Role Configuration
  # pass

  # Polling Configuration
  # pass

  # Run Configuration - required

  instance_type = var.my_instance_type
  # The EC2 instance type to use while building the AMI, such as t2.small.

  # source_ami (string) - The source AMI whose root volume will be copied and provisioned on the currently running instance. 
  # This must be an EBS-backed AMI with a root volume snapshot that you have access to.

  # Run Configuration - optional

  # source_ami_filter (AmiFilterOptions) - Filters used to populate the source_ami field
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

  provisioner "shell" {
    script = "../scripts/setup_amazon_linux_nginx.sh"
  }
}