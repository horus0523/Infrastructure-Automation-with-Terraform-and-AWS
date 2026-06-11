variable "aws_region" {
  description = "AWS region where the lab resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "allowed_ssh_cidr" {
  description = "Single trusted IPv4 CIDR block allowed to access port 22 on both EC2 instances"
  type        = string
  default     = "127.0.0.1/32"

  validation {
    condition = can(regex("^[0-9]{1,3}(\\.[0-9]{1,3}){3}/[0-9]{1,2}$", var.allowed_ssh_cidr)) && can(cidrhost(var.allowed_ssh_cidr, 0))
    error_message = "allowed_ssh_cidr must be a valid IPv4 CIDR block such as 203.0.113.10/32."
  }
}

variable "nginx_dev_public_key" {
  description = "SSH public key contents for the dev EC2 key pair"
  type        = string

  validation {
    condition     = can(regex("^(ssh-rsa|ssh-ed25519|ecdsa-sha2-nistp(256|384|521))\\s+", trimspace(var.nginx_dev_public_key)))
    error_message = "nginx_dev_public_key must be a valid SSH public key string."
  }
}

variable "nginx_qa_public_key" {
  description = "SSH public key contents for the qa EC2 key pair"
  type        = string

  validation {
    condition     = can(regex("^(ssh-rsa|ssh-ed25519|ecdsa-sha2-nistp(256|384|521))\\s+", trimspace(var.nginx_qa_public_key)))
    error_message = "nginx_qa_public_key must be a valid SSH public key string."
  }
}

variable "common_tags" {
  description = "Optional extra tags applied to all resources"
  type        = map(string)
  default     = {}
}
