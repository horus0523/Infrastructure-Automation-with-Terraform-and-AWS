####### ssh #######
resource "aws_key_pair" "nginx-server-ssh" {
  key_name   = "${var.server_name}-ssh"
  public_key = var.public_key

  tags = merge(var.common_tags, {
    Name        = "${var.server_name}-ssh"
    Environment = var.environment
    Project     = "Infrastructure-Automation-with-Terraform-and-AWS"
  })
}
