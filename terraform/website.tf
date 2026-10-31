
resource "aws_s3_object" "website_index" {
  bucket = aws_s3_bucket.demo.id

  key          = "index.html"
  source       = "${path.module}/../index.html"
  content_type = "text/html"

  etag = filemd5("${path.module}/../index.html")
}
