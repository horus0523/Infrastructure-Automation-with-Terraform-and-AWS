#######  resource ####### 
data "aws_iam_policy_document" "nginx-server-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "nginx-server" {
  name               = "${var.server_name}-role"
  assume_role_policy = data.aws_iam_policy_document.nginx-server-assume-role.json

  tags = merge(var.common_tags, {
    Name        = "${var.server_name}-role"
    Environment = var.environment
    Project     = "Infrastructure-Automation-with-Terraform-and-AWS"
  })
}

resource "aws_iam_instance_profile" "nginx-server" {
  name = "${var.server_name}-instance-profile"
  role = aws_iam_role.nginx-server.name
}

resource "aws_instance" "nginx-server" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  ebs_optimized        = true
  monitoring           = true
  iam_instance_profile = aws_iam_instance_profile.nginx-server.name

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

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = merge(var.common_tags, {
    Name        = var.server_name
    Environment = var.environment
    Project     = "Infrastructure-Automation-with-Terraform-and-AWS"
  })
}
