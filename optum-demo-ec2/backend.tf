terraform {
    backend "s3" {
        key = "networking/optum-vpc/terraform.tfstate"
        dynamodb_table = "optum-tfstatelock-58709"
    }
}