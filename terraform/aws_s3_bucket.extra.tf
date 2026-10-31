resource "aws_s3_bucket" "extra_demo" {
  bucket = "${var.project_name}-${data.aws_caller_identity.current.account_id}-extra-${var.environment}"

  tags = {
    Name        = "Extra Demo Bucket"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Live demonstration"
  }
}

resource "aws_s3_bucket_public_access_block" "extra_demo" {
  bucket = aws_s3_bucket.extra_demo.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "extra_demo" {
  bucket = aws_s3_bucket.extra_demo.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "extra_demo" {
  bucket = aws_s3_bucket.extra_demo.id

  versioning_configuration {
    status = "Enabled"
  }
}