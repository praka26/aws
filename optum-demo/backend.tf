terraform {
    backend "s3" {
        key = "networking/optum-vpc/terraform.tfstate"
        dynamodb_table = "globo-tfstatelock-58709"
    }
}