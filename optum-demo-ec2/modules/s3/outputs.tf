output "bucket_arn" {
  value       = aws_s3_bucket.b.arn
  description = "Bucket ARN"
}
output "bucket_name" {
  value       = aws_s3_bucket.b.id
  description = "Bucket ID"
}