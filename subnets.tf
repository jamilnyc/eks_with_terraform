resource "aws_subnet" "public_01" {
  vpc_id = aws_vpc.main.id

  # Portion of VPC CIDR allocated to this subnet
  cidr_block = "192.168.0.0/18"

  # TODO: Store in a variable
  availability_zone = "us-east-1a"

  # EKS Requirement
  map_public_ip_on_launch = true

  tags = {
    Name = "EKS Public Subnet 01"

    # Allow cluster to discover this subnet
    "kubernetes.io/cluster/MyAwesomeCluster" = "shared"

    # Allows public load balancer created by EKS to be placed in this subnet
    "kubernetes.io/role/elb" = 1
    terraform                = "true"
  }
}

resource "aws_subnet" "public_02" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "192.168.64.0/18"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name                        = "EKS Public Subnet 02"
    "kubernetes.io/cluster/MyAwesomeCluster" = "shared"
    "kubernetes.io/role/elb"    = 1
    terraform                   = "true"
  }
}

resource "aws_subnet" "private_01" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.128.0/18"
  availability_zone = "us-east-1a"

  tags = {
    Name                        = "EKS Private Subnet 01"
    "kubernetes.io/cluster/MyAwesomeCluster" = "shared"

    # Deploy private load balancer
    "kubernetes.io/role/internal-elb" = 1
    terraform                         = "true"
  }
}

resource "aws_subnet" "private_02" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.192.0/18"
  availability_zone = "us-east-1b"

  tags = {
    Name                              = "EKS Private Subnet 02"
    "kubernetes.io/cluster/MyAwesomeCluster"       = "shared"
    "kubernetes.io/role/internal-elb" = 1
    terraform                         = "true"
  }
}