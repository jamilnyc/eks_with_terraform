# This role is used by EKS to create resources
resource "aws_iam_role" "eks_cluster_role" {
  name               = "eks-cluster-role"
  assume_role_policy = <<POLICY
{
	"Version": "2012-10-17",
	"Statement": [{
		"Effect": "Allow",
		"Principal": {
			"Service": "eks.amazonaws.com"
		},
		"Action": "sts:AssumeRole"
	}]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  # Managed Policy that allows various EC2 and ELB actions
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_cluster" "my_cluster" {
  name     = "MyAwesomeCluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  # Kubernetes Version
  version = "1.20"

  vpc_config {
    endpoint_private_access = false

    # Connecting from local machine to cluster
    endpoint_public_access = true

    subnet_ids = [
      aws_subnet.public_01.id,
      aws_subnet.public_02.id,
      aws_subnet.private_01.id,
      aws_subnet.private_02.id
    ]
  }

  # Make sure the policy (with relevant Actions) is attached to the role before trying to assume the role
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}