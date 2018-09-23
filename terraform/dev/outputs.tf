output "ec2_id" {
    value = "${module.webserver.ec2_id}"
}

output "ec2_dns" {
    value = "${module.webserver.ec2_dns}"
}

output "ec2_url" {
    value = "http://${module.webserver.ec2_dns}"
}

output "ec2_ip" {
    value = "${module.webserver.ec2_ip}"
}

output "sg_id" {
    value = "${module.webserver.sg_id}"
}
