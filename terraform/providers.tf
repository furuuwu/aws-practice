terraform {

  # terraform version
  required_version = ">=1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.51.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }
}

# Configuration options
provider "aws" {
  region = var.my_region
}
