#Create an elastice load balancer security group allowing inbound HTTP
resource "aws_security_group" "elb" {
  name        = "test-elb"
  description = "used for Pluralsight demo1"
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
  description = "Used for Pluralsight demo1"
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