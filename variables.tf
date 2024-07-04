# define varables related to a AWS VPC resource including prefix, region, vpc_cidr and subnet_cidr
variable "prefix" {
  description = "The prefix to be used for the VPC name"
  type = string
}

variable "region" {
  description = "The AWS region to deploy the VPC"
  type = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type = string
}

variable "public_subnet_1_cidr" {
    description = "The CIDR block for the public subnet 1"
    type        = string
}
variable "public_subnet_2_cidr" {
    description = "The CIDR block for the public subnet 2"
    type        = string
}
variable "private_subnet_1_cidr" {
    description = "The CIDR block for the private subnet 1"
    type        = string
}
variable "private_subnet_2_cidr" {
    description = "The CIDR block for the private subnet 2"
    type        = string
}
variable "secure_subnet_1_cidr" {
    description = "The CIDR block for the secure subnet 1"
    type        = string
}
variable "secure_subnet_2_cidr" {
    description = "The CIDR block for the secure subnet 2"
    type        = string
}