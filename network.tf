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

#add 6 subnets for the above VPC, two public, two pricate and two secure, each in a different AZ
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix}-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix}-public-subnet-2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.prefix}-pivate-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_2_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${var.prefix}-private-subnet-2"
  }
}

resource "aws_subnet" "secure_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.secure_subnet_1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.prefix}-secure-subnet-1"
  }
}

resource "aws_subnet" "secure_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.secure_subnet_2_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${var.prefix}-secure-subnet-2"
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
  subnet_id     = aws_subnet.private_subnet_1.id
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

# add a route table association for the public subnet 1
resource "aws_route_table_association" "public_subnet_1_rt_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
} 

# add a route table association for the public subnet 2
resource "aws_route_table_association" "public_subnet_2_rt_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

# add a route table association for the private subnet 1
resource "aws_route_table_association" "private_subnet_1_rt_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private.id
}

# add a route table association for the private subnet 2
resource "aws_route_table_association" "private_subnet_2_rt_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private.id
}
