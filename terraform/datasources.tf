# not actually using this one, but will stay here just for reference
data "aws_ami" "amazon_linux_ami" {

  # filter to get the correct ami
  /*
  i can look it up in the aws platform or use some other tool, like this

  https://documentation.ubuntu.com/aws/en/latest/aws-how-to/instances/find-ubuntu-images/
    
    ubuntu/$PRODUCT/$RELEASE/stable/current/$ARCH/$VIRT_TYPE/$VOL_TYPE/ami-id
    PRODUCT: server, server-minimal or pro-server
    RELEASE: jammy, 22.04, focal, 20.04, bionic, 18.04, xenial, or 16.04
    ARCH: amd64 or arm64
    VIRT_TYPE: pv or hvm
    VOL_TYPE: ebs-gp3 (for >=23.10), ebs-gp2 (for <=23.04), ebs-io1, ebs-standard, or instance-store
  */

  # anyway, a particular ami name would be al2023-ami-2023.4.20240513.0-kernel-6.1-x86_64
  # i just removed the date

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }

  most_recent = true
  owners      = ["137112412989"]
}


data "aws_ami" "app_ami" {
  most_recent = true
  name_regex  = "app-*"
  owners      = ["self"]
}
