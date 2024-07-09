# add a VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
    # add enable_dns_support and enable_dns_hostnames
    enable_dns_support = true
    enable_dns_hostnames = true

  tags = {
    Name = "${var.prefix}-vpc"
  }
}


resource "aws_subnet" "public_subnet" {
  count = var.number_of_public_subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr,3,count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix}-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = var.number_of_private_subnets 
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr,3,var.number_of_public_subnets + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix}-private-subnet-${count.index}"
  }
}

resource "aws_subnet" "secure_subnet" {
  count = var.number_of_secure_subnets 
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr,3,var.number_of_public_subnets + var.number_of_secure_subnets  + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix}-private-subnet-${count.index}"
  }
}
# add an internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.prefix}-igw"
  }
}

# add an Elastic IP with domain attribute
resource "aws_eip" "eip" {
  domain   = "vpc"
  tags = {
    Name = "${var.prefix}-eip"
  }
}

# add a NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet[0].id
  tags = {
    Name = "${var.prefix}-nat"
  }
}

# add a route table for the public subnet which will have a route to the internet via the igw
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.prefix}-public-rt"
  }
}

# add a route table for the private subnet which will have a route to the internet via the nat gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "${var.prefix}-private-rt"
  }
}


# add a route table association for the public subnet
resource "aws_route_table_association" "public_subnet_rt_association" {
  count = var.number_of_public_subnets
  
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public.id
} 


# add a route table association for the private subnet
resource "aws_route_table_association" "private_subnet_rt_association" {
  count = var.number_of_private_subnets
  
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private.id
}
