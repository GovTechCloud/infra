# Bastion / EC2 pública
resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Access only from admin IP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip] # Tu IP → máxima seguridad
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "free-tier-public-sg"
  }
}

# Capa privada (BD, backend, etc.)
resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Allow traffic only from public SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "free-tier-private-sg"
  }
}
