output "address" {
  # description = "IDs of EC2 instances"
  value       = aws_db_instance.rds_db_instance.address
}

output "endpoint" {
  # description = "IDs of EC2 instances"
  value       = aws_db_instance.rds_db_instance.endpoint
}

output "port" {
  # description = "IDs of EC2 instances"
  value       = aws_db_instance.rds_db_instance.port
}
