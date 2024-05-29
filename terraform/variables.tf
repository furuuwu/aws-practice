variable "my_ip" {
  type        = string
  description = "My IP"
}

variable "my_instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro" # what is available or is free tier depends on the machine
}

variable "my_region" {
  type    = string
  default = "eu-west-1"
}

variable "tls_algorithm" {
  type = string

}

variable "tls_rsa_bits" {
  type = number
}

variable "my_aws_key" {
  type        = string
  description = "AWS key to SSH into EC2 instances"
  default     = "mykey.pem"
}

variable "subnet_availability_zone" {
  type = string
}
