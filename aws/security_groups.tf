# Bastion SG (sin reglas inline)
resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Public bastion SG"
  vpc_id      = aws_vpc.main.id

<<<<<<< Updated upstream
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip]  # Tu IP → máxima seguridad
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
=======
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      description,
      tags
    ]
>>>>>>> Stashed changes
  }

  tags = {
    Name = "free-tier-public-sg"
  }
}


# Private SG (sin reglas inline)
resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Private layer"
  vpc_id      = aws_vpc.main.id

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      description,
      tags
    ]
  }

  tags = {
    Name = "free-tier-private-sg"
  }
}


# SSH al bastion
#resource "aws_security_group_rule" "public_ssh" {
#  type              = "ingress"
#  from_port         = 22
#  to_port           = 22
#  protocol          = "tcp"
#  cidr_blocks       = [var.admin_ip]
#  security_group_id = aws_security_group.public_sg.id
#  description       = "SSH from admin IP"
#}

# Egreso público
#resource "aws_security_group_rule" "public_egress" {
#  type              = "egress"
#  from_port         = 0
#  to_port           = 0
#  protocol          = "-1"
#  cidr_blocks       = ["0.0.0.0/0"]
#  security_group_id = aws_security_group.public_sg.id
#}

# Backend/RDS acepta desde bastion
# MySQL solo desde la EC2 bastion/backend
resource "aws_security_group_rule" "private_mysql_from_public" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public_sg.id
  security_group_id        = aws_security_group.private_sg.id
  description              = "MySQL from bastion EC2"
}



# Egreso privado
#resource "aws_security_group_rule" "private_egress" {
#  type              = "egress"
#  from_port         = 0
#  to_port           = 0
#  protocol          = "-1"
#  cidr_blocks       = ["0.0.0.0/0"]
#  security_group_id = aws_security_group.private_sg.id
#}
