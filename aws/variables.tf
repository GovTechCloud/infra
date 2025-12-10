variable "aws_region" {
  default = "us-east-1"
}

# Cambia esto por tu IP para seguridad
variable "admin_ip" {
<<<<<<< Updated upstream
  default = "0.0.0.0/0"   # Mejor usar: "X.X.X.X/32"
=======
  default = "0.0.0.0/0" # Mejor usar: "X.X.X.X/32"
>>>>>>> Stashed changes
}
