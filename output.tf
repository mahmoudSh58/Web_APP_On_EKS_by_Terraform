output "IRSA_role_id" {
  description = "IRSA Role ARN"
  value       = aws_iam_role.s3_list_role.arn
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}