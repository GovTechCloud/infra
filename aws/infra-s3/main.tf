terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# -------------------------------------------------------------------
# S3 Bucket para hosting estático
# -------------------------------------------------------------------
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = "ReactFrontendBucket"
  }
}

# Habilitar hosting estático
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Permisos públicos SOLO para lectura del contenido (requerido por hosting)
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.frontend_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Política del bucket para acceso público
resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend_bucket.arn}/*"
      }
    ]
  })
}

# Habilitar versionado opcional (recomendado, casi sin costo)
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.frontend_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
