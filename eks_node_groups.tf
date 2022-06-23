resource "aws_iam_role" "nodes_role" {
  name = "eks-node-group-role"

  # Nodes are EC2 instances that make up the cluster
  assume_role_policy = <<POLICY
{
	"Version": "2012-10-17",
	"Statement": [{
		"Effect": "Allow",
		"Principal": {
			"Service": "ec2.amazonaws.com"
		},
		"Action": "sts:AssumeRole"
	}]
}
POLICY
}

# Allows various EC2 actions
resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes_role.name
}

# Allows various EC2 network actions
resource "aws_iam_role_policy_attachment" "networking_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes_role.name
}

resource "aws_iam_role_policy_attachment" "read_container_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes_role.name
}

resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "my-awesome-nodes"
  node_role_arn   = aws_iam_role.nodes_role.arn

  # Nodes are only in private subnets, load balancers can be in public subnet
  subnet_ids = [
    aws_subnet.private_01.id,
    aws_subnet.private_02.id
  ]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  ami_type      = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
  disk_size     = 20

  force_update_version = false

  instance_types = ["t2.micro"]
  labels = {
    role = "nodes"
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.networking_policy,
    aws_iam_role_policy_attachment.read_container_registry_policy
  ]
}