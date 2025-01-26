provider "aws" {
  region = "us-east-1"  # Região da AWS onde as filas serão criadas
}

# Criar a fila SQS: hackathon-video-processado
resource "aws_sqs_queue" "hackathon_video_processado_queue" {
  name                        = "hackathon-video-processado"  # Nome da fila
  visibility_timeout_seconds   = 30  # Timeout de visibilidade (em segundos)
  message_retention_seconds    = 86400  # Tempo de retenção da mensagem (24 horas)

  tags = {
    Name        = "hackathon-video-processado"
    Environment = "Dev"
  }
}

# Criar a fila SQS: hackathon-video-processado-zip
resource "aws_sqs_queue" "hackathon_video_processado_zip_queue" {
  name                        = "hackathon-video-processado-zip"  # Nome da fila
  visibility_timeout_seconds   = 30  # Timeout de visibilidade (em segundos)
  message_retention_seconds    = 86400  # Tempo de retenção da mensagem (24 horas)

  tags = {
    Name        = "hackathon-video-processado-zip"
    Environment = "Dev"
  }
}
