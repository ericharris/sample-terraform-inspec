variable "region" {
  default = "us-east-1"
}
variable "ec2_ami" {}
variable "ec2_name" {}
variable "ec2_instance_type" {}
variable "mytags" {
  type = "map"
}