resource "aws_nat_gateway" "nat_gw_01" {
  # NAT Gateways belong in a public subnet
  subnet_id = aws_subnet.public_01.id

  # Associate the Elastic IP with the NAT Gateway
  allocation_id = aws_eip.nat_eip_01.id

  tags = {
    Name      = "EKS NAT 01"
    terraform = "true"
  }
}

resource "aws_nat_gateway" "nat_gw_02" {
  subnet_id     = aws_subnet.public_02.id
  allocation_id = aws_eip.nat_eip_02.id

  tags = {
    Name      = "EKS NAT 02"
    terraform = "true"
  }
}