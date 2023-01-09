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