output "lambda_function_name" {
  value = aws_lambda_function.process_video.function_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.video_bucket.id
}

output "sqs_queue_url" {
  value = aws_sqs_queue.video_queue.url
}
