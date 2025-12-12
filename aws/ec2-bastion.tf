############################################
# KEY PAIR (SSH)
############################################
resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key"
  public_key = tls_private_key.bastion_key.public_key_openssh
}

resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

############################################
# AMI AMAZON LINUX 2
############################################
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

############################################
# EC2 BASTION (SUBNET PÚBLICA)
############################################
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  key_name                    = aws_key_pair.bastion_key.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y mysql
  EOF

  tags = {
    Name = "bastion-ec2"
  }
}

############################################
# OUTPUTS
############################################
output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}
