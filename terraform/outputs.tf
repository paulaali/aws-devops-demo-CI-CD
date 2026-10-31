output "s3_bucket_name" {
  description = "Name of the demonstration S3 bucket"
  value       = aws_s3_bucket.demo.bucket
}

output "aws_account_id" {
  description = "AWS account used for deployment"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS deployment region"
  value       = var.aws_region
}
