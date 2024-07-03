# add aws provider using ap-southeast-2 region
provider "aws" {
  region = "ap-southeast-2"
}

# add terraform block with aws version 5.40.0 as provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40.0"
    }
  }
}

# add a VPC resource
resource "aws_vpc" "main" {
  cidr_block       = "192.168.1.0/25"
  instance_tenancy = "default"
    # add enable_dns_support and enable_dns_hostnames
    enable_dns_support = true
    enable_dns_hostnames = true

  tags = {
    Name = "iac-lab-liangtian-wang"
  }
}
