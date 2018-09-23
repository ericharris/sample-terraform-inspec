# Use the aws provider to provision in AWS
provider "aws" {
  region = "${var.region}"
}

# Create the webserver, passing config settings from terraform.tfvars
module "webserver" {
  source = "../modules/webserver/"
  ec2_ami = "${var.ec2_ami}"
  ec2_name = "${var.ec2_name}"
  ec2_instance_type = "${var.ec2_instance_type}"
  mytags = "${var.mytags}"
}
