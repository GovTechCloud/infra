variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nombre único del bucket S3 para hosting"
  type        = string
}
