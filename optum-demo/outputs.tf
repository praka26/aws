#############################################################################
# OUTPUTS
#############################################################################

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "db_subnet_group" {
  value = module.vpc.database_subnet_group
}

output "public_subnets" {
  value = module.vpc.public_subnets
}
/* output "bucket_name"  {
  value = module.s3.s3_bucket_id
}

output "bucket_arn"  {
  value = module.s3.s3_bucket_arn
} */
  


