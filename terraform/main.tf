# VPC

resource "aws_vpc" "dev_vpc" {
  # cidr_block = "10.0.0.0/16"
  cidr_block = "10.123.0.0/16"
  tags = {
    Name = "dev_vpc"
  }

  #
  enable_dns_support   = true # this is the default but just to be sure
  enable_dns_hostnames = true
}


# SUBNETS

resource "aws_subnet" "dev_public_subnet" {
  vpc_id = aws_vpc.dev_vpc.id
  # cidr_block = "10.0.1.0/24"
  cidr_block = "10.123.1.0/24"
  tags = {
    Name = "dev_public_subnet"
  }

  #
  map_public_ip_on_launch = true
  availability_zone       = var.subnet_availability_zone
}


# INTERNET GATEWAY

resource "aws_internet_gateway" "dev_internet_gw" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = "dev_internet_gw"
  }
}


# ROUTES

resource "aws_route_table" "dev_public_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = "dev_public_rt"
  }
}

resource "aws_route" "default_r" {
  route_table_id = aws_route_table.dev_public_rt.id
  # destination_cidr_block    = "10.0.1.0/22"
  destination_cidr_block = "0.0.0.0/0" # all hit this

  #
  gateway_id = aws_internet_gateway.dev_internet_gw.id
  # vpc_peering_connection_id = "pcx-45ff3dc1"
}

resource "aws_route_table_association" "dev_public_rt_association" {
  subnet_id      = aws_subnet.dev_public_subnet.id
  route_table_id = aws_route_table.dev_public_rt.id
}



# SSH

resource "tls_private_key" "mykey" {
  algorithm = var.tls_algorithm
  rsa_bits  = var.tls_rsa_bits
}

resource "aws_key_pair" "mykey" {
  key_name   = var.my_aws_key
  public_key = tls_private_key.mykey.public_key_openssh
}

output "private_key_out" {
  value     = tls_private_key.mykey.private_key_pem
  sensitive = true
}

output "public_key_out" {
  value = tls_private_key.mykey.public_key_openssh
}

# i may add a prod environment later... maybe
resource "aws_security_group" "dev_sg" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "SSH Ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"] # only my IPs
  }

  ingress {
    description = "HTTP Ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ig it's fine for now
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # any
  }
}

# EC2

# this is here just for reference
/*
resource "aws_instance" "prod_ec2" {
  ami           = data.aws_ami.amazon_linux_ami.id
  instance_type = var.my_instance_type

  tags = {
    Name = "prod_ec2"
  }

  #
  key_name               = aws_key_pair.mykey.key_name
  vpc_security_group_ids = [aws_security_group.dev_sg.id]
  subnet_id              = aws_subnet.dev_public_subnet.id
  user_data              = file("userdata.tpl")

  # you can increase the size for eg. Careful to stay under the free tier.
  root_block_device {
    volume_size = 10 # default is 8
  }
}
*/
resource "aws_instance" "web_app" {
  instance_type          = var.my_instance_type
  ami                    = data.aws_ami.app_ami.id
  key_name               = aws_key_pair.mykey.key_name
  vpc_security_group_ids = [aws_security_group.dev_sg.id]
  subnet_id              = aws_subnet.dev_public_subnet.id
  tags = {
    Name = "web_app"
  }
}

output "public_ip" {
  value       = aws_instance.web_app.public_ip
  description = "EC2 Public IP"
}

