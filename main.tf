data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

data "aws_vpc" "default" {
  default = true
}

module "WebApp_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name           = "WebApp_sg"
  description    = "Security group for WebApp_sg"
  vpc_id         = data.aws_vpc.default.id

  ingress_rules  =  ["https-443-tcp","http-80-tcp"]
  egress_rules   =  ["all-all"]
  }

resource "aws_instance" "web" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.WebAppSG.id]

  tags = {
    Name = "HelloWorld"
  }
}
