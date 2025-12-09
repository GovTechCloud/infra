variable "aws_region" {
  default = "us-east-1"
  type    = string
}

# Cambia esto por tu IP para seguridad
variable "admin_ip" {
  default = "0.0.0.0/0" # Mejor usar: "X.X.X.X/32"
  type    = string
}
