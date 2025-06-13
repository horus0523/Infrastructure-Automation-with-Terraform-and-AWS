#######  output ####### 
output "server_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.nginx-server.public_ip
}

output "server_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.nginx-server.public_dns
}

output "server_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.nginx-server.private_ip
  sensitive   = true # Marca como sensible para evitar mostrar en logs
}

output "server_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.nginx-server.id
  sensitive   = true # Marca como sensible para evitar mostrar en logs
}

output "server_security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.nginx-server-sg.id
}

output "server_availability_zone" {
  description = "Availability zone of the EC2 instance"
  value       = aws_instance.nginx-server.availability_zone
}

output "server_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.nginx-server.arn
}
