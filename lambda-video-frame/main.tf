provider "aws" {
  region = "us-east-1"
}

# Criar Role para Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.video_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "s3.amazonaws.com" }
        Action    = "SQS:SendMessage"
        Resource  = aws_sqs_queue.video_queue.arn
        Condition = {
          ArnEquals = { "aws:SourceArn" = aws_s3_bucket.video_bucket.arn }
        }
      }
    ]
  })
}

# Permissões para acessar S3 e SQS
resource "aws_iam_policy" "lambda_policy" {
  name = "lambda_s3_sqs_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:ListBucket", "s3:PutObject"]
        Resource = [
          "${aws_s3_bucket.video_bucket.arn}", "${aws_s3_bucket.video_bucket.arn}/*",
          "arn:aws:s3:::fiap-grupo57-hackathon", "arn:aws:s3:::fiap-grupo57-hackathon/*",
          "arn:aws:s3:::fiap-grupo57-hackathon-zip", "arn:aws:s3:::fiap-grupo57-hackathon-zip/*",
        ]
      },
      {
        Effect = "Allow"
        Action = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes", "sqs:sendmessage"]
        Resource = [
          aws_sqs_queue.video_queue.arn,
          "arn:aws:s3:::fiap-grupo57-hackathon",
          "arn:aws:s3:::fiap-grupo57-hackathon-zip",
          "arn:aws:sqs:us-east-1:026131848615:video-completed-queue"
        ]
      },
      {
        Effect   = "Allow"
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_role.name
}

# Criar Bucket S3 para vídeos
resource "aws_s3_bucket" "video_bucket" {
  bucket = "fiap-grupo57-hackathon-terraform"
}

# Criar um objeto no S3 com o código da Lambda
resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.video_bucket.id
  key    = "processVideoS3.zip"
  source = "./processVideoS3.zip" # Caminho do arquivo ZIP local
  etag   = filemd5("./processVideoS3.zip")
}

# Criar Fila SQS
resource "aws_sqs_queue" "video_queue" {
  name                       = "video-processing-queue"
  visibility_timeout_seconds = 300
  message_retention_seconds  = 86400
}

# Permitir que SQS invoque a Lambda
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.video_queue.arn
  function_name    = aws_lambda_function.process_video.arn
  batch_size       = 1
}

# Criar um evento para acionar a Lambda quando um vídeo for enviado ao S3
resource "aws_s3_bucket_notification" "s3_event" {
  bucket = aws_s3_bucket.video_bucket.id

  queue {
    queue_arn = aws_sqs_queue.video_queue.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

# Criar a Função Lambda
resource "aws_lambda_function" "process_video" {
  function_name = "processVideoS3"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  timeout       = 300 # 5 minutos
  memory_size   = 1024

  source_code_hash = filebase64sha256("processVideoS3.zip")

  s3_bucket = aws_s3_bucket.video_bucket.id
  s3_key    = aws_s3_object.lambda_zip.key

  depends_on = [aws_s3_object.lambda_zip]

  environment {
    variables = {
      NODE_ENV  = "production"
      SQS_QUEUE = aws_sqs_queue.video_queue.url
    }
  }

}
