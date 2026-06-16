####### Variables #######
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0440d3b780d96b29d"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "server_name" {
  description = "Web server name"
  type        = string
  default     = "nginx-server"
}

variable "environment" {
  description = "Application environment"
  type        = string
  default     = "test"
}

variable "aws_region" {
  description = "AWS region where the lab resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "allowed_ssh_cidr" {
  description = "Single trusted CIDR block allowed to access port 22"
  type        = string
}

variable "public_key" {
  description = "SSH public key contents for the EC2 key pair"
  type        = string
}

variable "common_tags" {
  description = "Optional extra tags applied to module resources"
  type        = map(string)
  default     = {}
}
