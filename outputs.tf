output "vpc_id" {
  value       = aws_vpc.main.id
  sensitive   = false
  description = "ID of the VPC that hosts the EKS cluster"
}

output "eks_admin_arn" {
  value = aws_iam_role.eks_admin_role.arn
  sensitive = false
}