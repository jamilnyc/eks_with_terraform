output "vpc_id" {
  value       = aws_vpc.main.id
  sensitive   = false
  description = "ID of the VPC that hosts the EKS cluster"
}