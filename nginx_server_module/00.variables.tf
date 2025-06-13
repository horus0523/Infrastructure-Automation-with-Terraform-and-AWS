####### Variables #######
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-0440d3b780d96b29d"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "server_name" {
  description = "Web server name"
  default     = "nginx-server"
}

variable "environment" {
  description = "Application environment"
  default     = "test"
}
