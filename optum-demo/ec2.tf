######################## INSTANCES #############################################

##Create an EC2 instance for the Web server
resource "aws_instance" "web" {
  ami             = "${lookup(var.amis, var.aws_region)}"
  instance_type   = "t3.micro"
  subnet_id       = "${module.vpc.public_subnets[0]}"
}