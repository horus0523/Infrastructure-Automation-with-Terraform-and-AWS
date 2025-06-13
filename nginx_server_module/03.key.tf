####### ssh #######
# Generate ssh keys with:
#ssh-keygen -t ed25519 -C "dev@nginx-server" -f ssh-keys/nginx-server-dev.key -N ""
#ssh-keygen -t ed25519 -C "qa@nginx-server" -f ssh-keys/nginx-server-qa.key -N ""
resource "aws_key_pair" "nginx-server-ssh" {
  key_name   = "${var.server_name}-ssh"
  public_key = file("ssh-keys/${var.server_name}.key.pub")

  tags = {
    Name        = "${var.server_name}-ssh"
    Environment = "${var.environment}"
    Owner       = "horus0523@gmail.com"
    Team        = "DevOps"
    Project     = "Infrastructure-Automation-with-Terraform-and-AWS"
  }
}
