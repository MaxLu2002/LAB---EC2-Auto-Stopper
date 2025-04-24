output "vpc_id" {
  value       = aws_vpc.vpc[*].id
  description = "vpc id"
}

output "public_subnet_id" {
  value       = aws_subnet.public_subnet[*].id
  description = "public subnet id"
}

output "private_subnet_id" {
  value       = aws_subnet.private_subnet[*].id
  description = "private subnet id"
}


