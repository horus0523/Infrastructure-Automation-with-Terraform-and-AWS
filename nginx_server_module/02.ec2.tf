#######  resource ####### 
resource "aws_instance" "nginx-server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF

  key_name = aws_key_pair.nginx-server-ssh.key_name

  vpc_security_group_ids = [
    aws_security_group.nginx-server-sg.id
  ]

  tags = {
    Name        = var.server_name
    Environment = var.environment
    Owner       = "horus0523@gmail.com"
    Team        = "DevOps"
    Project     = "Infrastructure-Automation-with-Terraform-and-AWS"
  }
}

# connect to ec2 instance with:
#ssh -i ./ssh-keys/nginx-server-dev.key ec2-user@publicIP # Replace `publicIP` with your actual public IP. This is shown in the output
#ssh -i ./ssh-keys/nginx-server-qa.key ec2-user@publicIP # Replace `publicIP` with your actual public IP. This is shown in the output
