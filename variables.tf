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

variable "number_of_public_subnets" {
  description = "Total number of public subnets to be created"
  type = number
  default = 2
}

variable "number_of_private_subnets" {
  description = "Total number of private subnets to be created"
  type = number
  default = 2
}

variable "number_of_secure_subnets" {
  description = "Total number of secure subnets to be created"
  type = number
  default = 2
}