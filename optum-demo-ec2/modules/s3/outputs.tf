output "bucket_arn" {
  value       = aws_s3_bucket.demos3.arn
  description = "Bucket ARN"
}
output "bucket_name" {
  value       = aws_s3_bucket.demos3.id
  description = "Bucket ID"
}