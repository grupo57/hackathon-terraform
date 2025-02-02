provider "aws" {
  region = "us-east-1"
}

# Criar o primeiro bucket: fiap-grupo57-hackathon
resource "aws_s3_bucket" "fiap_grupo57_hackathon" {
  bucket = "fiap-grupo57-hackathon"

  tags = {
    Name        = "fiap-grupo57-hackathon"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "fiap_grupo57_hackathon_versioning" {
  bucket = aws_s3_bucket.fiap_grupo57_hackathon.id
  versioning_configuration {
    status = "Enabled"
  }
}

# resource "aws_s3_bucket_acl" "fiap_grupo57_hackathon_acl" {
#   bucket = aws_s3_bucket.fiap_grupo57_hackathon.id
#   acl    = "public-read"
# }

# Criar o segundo bucket: fiap-grupo57-hackathon-zip
resource "aws_s3_bucket" "fiap_grupo57_hackathon_zip" {
  bucket = "fiap-grupo57-hackathon-zip"

  tags = {
    Name        = "fiap-grupo57-hackathon-zip"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "fiap_grupo57_hackathon_zip_versioning" {
  bucket = aws_s3_bucket.fiap_grupo57_hackathon_zip.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket hackathon-app-api-deploy-bucket

resource "aws_s3_bucket" "hackathon-app-api-deploy-bucket" {
  bucket = "hackathon-app-api-deploy-bucket"

  tags = {
    Name        = "hackathon-app-api-deploy-bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "hackathon-app-api-deploy-bucket_versioning" {
  bucket = aws_s3_bucket.hackathon-app-api-deploy-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}