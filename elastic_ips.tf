# Create Elastic IP addresses for the NAT Gateways

resource "aws_eip" "nat_eip_01" {
  # Gateway needs to exist first
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name      = "EKS NAT Gateway 01 EIP"
    terraform = "true"
  }
}

resource "aws_eip" "nat_eip_02" {
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name      = "EKS NAT Gateway 02 EIP"
    terraform = "true"
  }
}
