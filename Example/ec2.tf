provider "aws" {
  region = "us-east-1"
  profile = "dev"
}

variable "prefix" {
  description = "servername prefix"
  default = "gritfyapp"
}

resource "aws_instance" "web" {
  ami           = "ami-007a18d38016a0f4e"
  instance_type = "t3.medium"
  count = 1
  vpc_security_group_ids = [
    "sg-0d8bdc71aee9f"
  ]
  user_data = <<EOF
#!/bin/bash
echo "Copying the SSH Key Of Jenkins to the server"
echo -e "#Jenkins\nssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAB*******************F/SNZPMT4Qm/RVgBbIhG8VsoDhGM0tgIzWyTaNxDPSDx/yzJ8FQwCKOH6YR3RugLvTU+jDKvI8BWOnMM5cgrbfKbBssUyJSdWI86py4bi05A3X6O5+6xS6IvQbZwlbJiu/DbgAcvGLiq1mDi77O+DvU22RNgCB9hGddryWc3nTDOMyVaex5EdfvgxEli1DAM2YYr/DdxVvdzkrP/1fol6t+XT4FeQyW/KcQuRA53qG0aSYlSN/6NUO3OGuLn jenkins@gritfy.com\nssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAPlhbcDQ06FO8euMxVvsglV4gqhD0v1l8h+bk/X+eJWqQMHZ0CXzsywTe+32zdu9JydbwiQiMIlDwFy0nsyX+quzLupYejrAtFFOKoFSzNB3ng69KSV+M6kUZdXHfP9PjYt5wZfOW0h/W9+2Oz406UjpeaW5t9XPftx784nLsocR3d7mosIgLMXkFLijOfJknhEKWxMmvkwV15fcuPfpRhvJkFDCmpFMBTaOwE2rDuj22r0Z4bI78CdtZgTSB5eK1YebOtEUllB+pwoMA40cNgnivd ubuntu@gritfy.com" >> /home/ubuntu/.ssh/authorized_keys

echo "Mount NFS"
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-******.efs.us-east-1.amazonaws.com:/ /sharedrive

echo "Installing NodeExporter"
mkdir /home/ubuntu/node_exporter
cd /home/ubuntu/node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz
tar node_exporter-1.2.2.linux-amd64.tar.gz
cd node_exporter-1.2.2.linux-amd64
./node_exporter &

echo "Changing Hostname"
hostname "${var.prefix}${count.index+1}"
echo "${var.prefix}${count.index+1}" > /etc/hostname



EOF
  subnet_id = "subnet-00514b9f4cd6d4"
  tags = {
    Name = "${var.prefix}${count.index}"
  }
}

output "instances" {
  value       = "${aws_instance.web.*.private_ip}"
  description = "PrivateIP address details"
}