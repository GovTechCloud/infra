############################################
# VARIABLES
############################################

variable "db_username" {
  default = "admin"
}

variable "db_name" {
  default = "GovTechCloud"
}

############################################
# PASSWORD SEGURO
############################################

resource "random_password" "db_password" {
  length  = 16
  special = true
}

############################################
# DB SUBNET GROUP (SUBNETS PRIVADAS)
############################################

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "govtechcloud-subnet-group"

  subnet_ids = [
    aws_subnet.private.id,
    aws_subnet.private_2.id # 👈 asegúrate de tener una segunda subnet privada
  ]

  tags = {
    Name = "GovTechCloud subnet group"
  }
}

############################################
# RDS MYSQL
############################################

resource "aws_db_instance" "govtech_rds" {
  identifier        = "govtechcloud-db"
  db_name           = var.db_name
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  username = var.db_username
  password = random_password.db_password.result

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  publicly_accessible = false
  skip_final_snapshot = true
  deletion_protection = false
  apply_immediately   = true

  tags = {
    Name = "GovTechCloud-RDS"
  }
}

############################################
# OUTPUTS
############################################

output "rds_endpoint" {
  value = aws_db_instance.govtech_rds.endpoint
}

output "rds_port" {
  value = aws_db_instance.govtech_rds.port
}

output "db_username" {
  value = var.db_username
}

output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}

