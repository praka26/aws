#############################################################################
# PROVIDERS
#############################################################################

provider "aws" {
  region = var.region

  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  #access_key = "AKIAZZ5SAV3H2OXOPQH6"
  #secret_key = "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"
}
