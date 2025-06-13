####### tfstate #######
# Configures the Terraform "backend" to store the state file (`tfstate`) in a specific S3 bucket
# For this to work, the S3 bucket must be created
terraform {
  backend "s3" {
    bucket = "infrastructure-automatization-with-terraform"
    key    = "infrastructure-automatization/terraform.tfstate"
    region = "us-east-1"
    #encrypt = true # Enables SSE-S3 encryption
  }
}

####### modules #######
module "nginx_server_dev" {
  source = "./nginx_server_module"

  ami_id        = "ami-0440d3b780d96b29d"
  instance_type = "t3.medium"
  server_name   = "nginx-server-dev"
  environment   = "dev"
}

module "nginx_server_qa" {
  source = "./nginx_server_module"

  ami_id        = "ami-0440d3b780d96b29d"
  instance_type = "t3.medium"
  server_name   = "nginx-server-qa"
  environment   = "qa"
}

# By default, Terraform modules save the outputs, they are not displayed
# They need to be configured

#######  output ####### 
output "nginx_dev_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.nginx_server_dev.server_public_ip
}

output "nginx_dev_dns" {
  description = "Public DNS of the EC2 instance"
  value       = module.nginx_server_dev.server_public_dns
}

output "nginx_dev_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.nginx_server_dev.server_private_ip
  sensitive   = true # Mark as sensitive to avoid showing in logs
}

output "nginx_dev_id" {
  description = "ID of the EC2 instance"
  value       = module.nginx_server_dev.server_instance_id
  sensitive   = true # Mark as sensitive to avoid showing in logs
}

output "nginx_dev_security_group_id" {
  description = "ID of the security group"
  value       = module.nginx_server_dev.server_security_group_id
}

output "nginx_dev_availability_zone" {
  description = "Availability zone of the EC2 instance"
  value       = module.nginx_server_dev.server_availability_zone
}

output "nginx_dev_arn" {
  description = "ARN of the EC2 instance"
  value       = module.nginx_server_dev.server_arn
}

output "nginx_qa_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.nginx_server_qa.server_public_ip
}

output "nginx_qa_dns" {
  description = "Public DNS of the EC2 instance"
  value       = module.nginx_server_qa.server_public_dns
}

output "nginx_qa_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.nginx_server_qa.server_private_ip
  sensitive   = true # Mark as sensitive to avoid showing in logs
}

output "nginx_qa_id" {
  description = "ID of the EC2 instance"
  value       = module.nginx_server_qa.server_instance_id
  sensitive   = true # Mark as sensitive to avoid showing in logs
}

output "nginx_qa_security_group_id" {
  description = "ID of the security group"
  value       = module.nginx_server_qa.server_security_group_id
}

output "nginx_qa_availability_zone" {
  description = "Availability zone of the EC2 instance"
  value       = module.nginx_server_qa.server_availability_zone
}

output "nginx_qa_arn" {
  description = "ARN of the EC2 instance"
  value       = module.nginx_server_qa.server_arn
}

####### import #######
# import resources to terraform
#resource "aws_instance" "server-web" {
# (resource arguments)
#}
