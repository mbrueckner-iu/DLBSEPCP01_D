# VPC primary setting
resource "aws_vpc" "primary_setting" {
  cidr_block = var.aws_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.aws_installation_name}-vpc-primary-setting"
  }
}

# Internet gateway primary setting
resource "aws_internet_gateway" "primary_setting" {
  vpc_id = aws_vpc.primary_setting.id

  tags = {
    Name = "${var.aws_installation_name}-internet-gateway-primary-setting"
  }
}

# Subnets
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.primary_setting.id
  count = length(var.aws_az_list)
  cidr_block = cidrsubnet(var.aws_vpc_cidr, 8, count.index)
  availability_zone = var.aws_az_list[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.aws_installation_name}-subnet-public-${count.index + 1}"
    Type = "Public"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.primary_setting.id
  count = length(var.aws_az_list)
  cidr_block = cidrsubnet(var.aws_vpc_cidr, 8, count.index + 10)
  availability_zone = var.aws_az_list[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.aws_installation_name}-subnet-private-${count.index + 1}"
    Type = "Private"
  }
}

# NAT gateway dynamic IP
resource "aws_eip" "nat_ip" {
  depends_on = [ aws_internet_gateway.primary_setting ]
  domain = "vpc"
  count = length(var.aws_az_list)

  tags = {
    Name = "${var.aws_installation_name}-nat-ip-${count.index + 1}"
  }
}

# NAT gateway primary setting
resource "aws_nat_gateway" "primary_setting" {
  depends_on = [ aws_internet_gateway.primary_setting ]
  count = length(var.aws_az_list)
  allocation_id = aws_eip.nat_ip[count.index].id
  subnet_id = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.aws_installation_name}-nat-gateway-primary-setting-${count.index + 1}"
  }
}

# Routing tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.primary_setting.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary_setting.id
  }

  tags = {
    Name = "${var.aws_installation_name}-route-table-public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.primary_setting.id
  count = length(var.aws_az_list)

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.primary_setting[count.index].id
  }

  tags = {
    Name = "${var.aws_installation_name}-route-table-private-${count.index + 1}"
  }
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}