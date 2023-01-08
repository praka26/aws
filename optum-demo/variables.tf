#############################################################################
# VARIABLES
#############################################################################

variable "region" {
  type    = string
  #default = "us-east-1"
}


variable "vpc_cidr_range" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "database_subnets" {
  type    = list(string)
  default = ["10.0.8.0/24", "10.0.9.0/24"]
}

variable "naming_prefix" {
  default = "IaCDemo"
}

variable "amis" {
  type = map(any)

  default = {
    us-east-1 = "ami-6869aa05"
    us-west-2 = "ami-7172b611"
  }
}

variable "client_username" {
  default = "nedadmin"
}

variable "key_name" {
  default = "nbellavance"
}

variable "aws_region" {
  default = "us-east-1"
}


#variable "client_password" {}

#variable "my_public_ip" {}

#variable "private_key_path" {}
variable "aws_access_key" {}
  
variable "aws_secret_key" {}
#variable "bucket_name" {}
   
variable "acl_value" {
  default = "private"
}
