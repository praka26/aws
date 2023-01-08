#############################################################################
# VARIABLES
#############################################################################

variable "region" {
  type    = string
  default = "us-east-1"
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
  type = map

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


#############################################################################
# PROVIDERS
#############################################################################

provider "aws" {
  region = var.region
}

#############################################################################
# DATA SOURCES
#############################################################################

data "aws_availability_zones" "azs" {}

#############################################################################
# RESOURCES
#############################################################################  

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "dev-vpc"
  cidr = var.vpc_cidr_range

  azs            = slice(data.aws_availability_zones.azs.names, 0, 2)
  public_subnets = var.public_subnets

  # Database subnets
  database_subnets = var.database_subnets
  database_subnet_group_tags = {
    subnet_type = "database"
  }

  tags = {
    Environment = "dev"
    Team        = "infra"
  }

}

#Create an elastice load balancer security group allowing inbound HTTP
resource "aws_security_group" "elb" {
  name        = "test-elb"
  description = "used for Pluralsight demo"
  vpc_id      = "${module.vpc.vpc_id}"

  #Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.naming_prefix}-elbsg"
  }
}

#Create a default security group to allow remote configuration of VM
resource "aws_security_group" "instance" {
  name        = "test-sg"
  description = "Used for Pluralsight demo"
  vpc_id      = "${module.vpc.vpc_id}"

  #Allow SSH access from anywhere (this can be restricted to local IP Address)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_range}"]
  }

  #Allow outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
   Name = "${var.naming_prefix}-dsg"
  }
}



########################## INSTANCES #############################################

##Create an EC2 instance for the Web server
resource "aws_instance" "web" {
  ami             = "${lookup(var.amis, var.aws_region)}"
  instance_type   = "t2.medium"
  subnet_id       = "${module.vpc.public_subnets[0]}"
  #key_name        = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  /* connection {
    user        = "ec2-user"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start",
    ]
  } */

  tags = {
    Name = "${var.naming_prefix}-web1"
  }
}



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


