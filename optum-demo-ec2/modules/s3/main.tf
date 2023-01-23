// Create S3 bucket

resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket-pravin1236"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}