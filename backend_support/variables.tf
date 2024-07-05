# define varables related to a AWS VPC resource including prefix, region, vpc_cidr and subnet_cidr
variable "prefix" {
  description = "The prefix to be used for the VPC name"
  type = string
  default = "liangtian-wang-iac-lab"
}

variable "region" {
  description = "The AWS region to deploy the VPC"
  type = string
  default = "ap-southeast-2"
}