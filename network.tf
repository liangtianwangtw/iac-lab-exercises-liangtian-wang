module "main_vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name = "${var.prefix}-vpc"
  cidr = var.vpc_cidr

  instance_tenancy = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  azs             = data.aws_availability_zones.available.names
  public_subnets  = [for i in range(var.number_of_public_subnets): cidrsubnet(var.vpc_cidr, 3, i)]
  private_subnets = [for i in range(var.number_of_private_subnets): cidrsubnet(var.vpc_cidr, 3, var.number_of_public_subnets + i)]
  intra_subnets = [for i in range(var.number_of_secure_subnets): cidrsubnet(var.vpc_cidr, 3, var.number_of_public_subnets + var.number_of_private_subnets + i)]
  
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  
  
  tags = {
    Name = "${var.prefix}-vpc"
  }
}

