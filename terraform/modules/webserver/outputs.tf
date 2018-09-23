output "ec2_id" {
    value = "${aws_instance.webapp-ec2.id}"
}

output "ec2_dns" {
    value = "${aws_instance.webapp-ec2.public_dns}"
}

output "ec2_ip" {
    value = "${aws_instance.webapp-ec2.public_ip}"
}

output "sg_id" {
    value = "${aws_security_group.webapp-sg.id}"
}
