// Create S3 bucket

resource "aws_s3_bucket" "demos3" {
    bucket = "${var.bucket_name}" 
   
}
resource "aws_s3_bucket_acl" "demos3_bucket_acl" {
  bucket = "${var.bucket_name}" 
  acl = "${var.acl_value}"  

}