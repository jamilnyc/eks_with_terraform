# Table used by both Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # There is an inherited route that already exists, that routes any traffic destined for 192.168.0.0/16 (from the VPC)
  # to the local network. Any traffic not destined for an internal IP will fallback to this rule below which will
  # route to the Internet Gateway.
  # See the "Main" Route Table in the Console, created with the VPC
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name      = "Public Route Table"
    terraform = "true"
  }
}

resource "aws_route_table" "private_01" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_01.id
  }

  tags = {
    Name      = "Private Route Table 01"
    terraform = "true"
  }
}

resource "aws_route_table" "private_02" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_02.id
  }

  tags = {
    Name      = "Private Route Table 02"
    terraform = "true"
  }
}

# Route Table Associations to the Subnets

# Since the destinations are the same, both public subnets are associated with one route table
resource "aws_route_table_association" "public_01" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_01.id
}

resource "aws_route_table_association" "public_02" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_02.id
}

resource "aws_route_table_association" "private_01" {
  route_table_id = aws_route_table.private_01.id
  subnet_id      = aws_subnet.private_01.id
}

resource "aws_route_table_association" "private_02" {
  route_table_id = aws_route_table.private_02.id
  subnet_id      = aws_subnet.private_02.id
}