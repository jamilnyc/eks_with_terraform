# NOTE Policy is not currently used
resource "aws_iam_policy" "viewer_policy" {
  name = "EKSViewNodesAndWorkloadsPolicy"
  description = "Grants read-only access to nodes and other cluster resources in EKS"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeNodegroup",
                "eks:ListNodegroups",
                "eks:DescribeCluster",
                "eks:ListClusters",
                "eks:AccessKubernetesApi",
                "ssm:GetParameter",
                "eks:ListUpdates",
                "eks:ListFargateProfiles"
            ],
            "Resource": "*"
        }
    ]
}
POLICY

  tags = {
    terraform = "true"
  }
}

resource "aws_iam_policy" "admin_policy" {
  name = "EKSAdminPolicy"
  description = "Admin Policy that allows performing all EKS actions and can pass the role to the EKS service to manage resources on your behalf"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "eks.amazonaws.com"
                }
            }
        }
    ]
}

POLICY

  tags = {
    terraform = "true"
  }
}

# Allow this role to be assumed
data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

resource "aws_iam_role" "eks_admin_role" {
  name = "eks-admin"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = [aws_iam_policy.admin_policy.arn]
  tags = {
    terraform = "true"
  }
}

# Allows users to assume role
data "aws_iam_policy_document" "assume_admin_policy_doc" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    resources = [aws_iam_role.eks_admin_role.arn]
  }
}
resource "aws_iam_policy" "assume_admin_policy" {
  name = "EKSAssumeEKSAdminPolicy"
  description = "Users/Groups with this policy can assume the eks-admin role"
  policy = data.aws_iam_policy_document.assume_admin_policy_doc.json

  tags = {
    terraform = "true"
  }
}

# Group of users that can assume the role
resource "aws_iam_user" "john" {
  name = "john"
  force_destroy = true
}

resource "aws_iam_group" "eks_devs" {
  name = "eks-devs"
}

resource "aws_iam_group_policy_attachment" "eks_admin_policy_attachment" {
  group      = aws_iam_group.eks_devs.name
  policy_arn = aws_iam_policy.assume_admin_policy.arn
}

resource "aws_iam_group_membership" "eks_admin_membership" {
  group = aws_iam_group.eks_devs.name
  name  = "EKS Admin Membership"
  users = [
    aws_iam_user.john.name
  ]
}