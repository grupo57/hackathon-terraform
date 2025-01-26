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

# resource "aws_s3_bucket_acl" "fiap_grupo57_hackathon_zip_acl" {
#   bucket = aws_s3_bucket.fiap_grupo57_hackathon_zip.id
#   acl    = "public-read"
# }
