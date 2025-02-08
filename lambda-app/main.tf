provider "aws" {
  region = "us-east-1" # Altere conforme necessário
}

resource "aws_s3_object" "lambda_zip" {
  bucket = "hackathon-app-api-deploy-bucket"
  key    = "laravel-api.zip"
  source = "./laravel-api.zip" # Caminho do seu arquivo ZIP
}

resource "aws_iam_role" "lambda_api_exec" {
  name = "lambda_api_exec_role"
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

resource "aws_iam_policy_attachment" "lambda_basic_exec" {
  name       = "lambda_basic_exec"
  roles      = [aws_iam_role.lambda_api_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "lambda_update_policy" {
  name        = "LambdaUpdatePolicy"
  description = "Permite atualizar o código da função Lambda"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "lambda:UpdateFunctionCode"
      ]
      Resource = aws_lambda_function.laravel_api.arn
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_update_attachment" {
  name       = "lambda_update_attachment"
  roles      = [aws_iam_role.lambda_api_exec.name]
  policy_arn = aws_iam_policy.lambda_update_policy.arn
}


resource "aws_lambda_function" "laravel_api" {
  function_name   = "laravel-api"
  s3_bucket       = "hackathon-app-api-deploy-bucket"
  s3_key          = aws_s3_object.lambda_zip.key
  runtime         = "provided.al2"
  handler         = "bootstrap.php" # Ajuste conforme necessário
  timeout         = 30
  memory_size     = 512
  role            = aws_iam_role.lambda_api_exec.arn

  layers = ["arn:aws:lambda:us-east-1:209497400698:layer:php-82-fpm:1"]
  
  environment {
    variables = {
      APP_ENV = "production"
      LOG_CHANNEL = "stderr"
    }
  }
}

resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "LaravelAPI"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.laravel_api.invoke_arn
}

resource "aws_apigatewayv2_route" "any_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.laravel_api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

output "api_gateway_url" {
  value = aws_apigatewayv2_api.api_gateway.api_endpoint
}
