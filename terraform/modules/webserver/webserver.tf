# Security group to assign to instance
resource "aws_security_group" "webapp-sg" {
  name = "${var.ec2_name}-ec2"

  # Merge tags from environment tfvars and create name tag
  tags = "${merge(map("Name", "${var.ec2_name}-sg"), var.mytags)}"

  # Ingress rules for ssh and port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["nnn.nnn.nnn.nnn/nn"] // Put the IP address your local machine will use to ssh to the instance
  }

  # Egress rules for port 80 and 443 to enable yum repo access
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instance for webserver
resource "aws_instance" "webapp-ec2" {
  ami           = "${var.ec2_ami}"
  key_name      = "webapp"                   // Use "webapp" AWS key pair for instance
  instance_type = "${var.ec2_instance_type}"

  # Merge tags from environment tfvars and create name tag
  tags                   = "${merge(map("Name", "${var.ec2_name}-ec2"), var.mytags)}"
  vpc_security_group_ids = ["${aws_security_group.webapp-sg.id}"]                     // Assign SG created above

  # Setup provisioner connection method
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("../../secrets/webapp.pem")}" // Location of "webapp" pem file on local system
  }

  # Remote execution provisioner to install httpd, set service to start on boot, start service, and create web page
  provisioner remote-exec {
    inline = [
      "sudo yum -y install httpd",
      "sudo chkconfig httpd on",
      "sudo service httpd start",
      "echo 'I know what you did last expense report' | sudo tee -a /var/www/html/index.html",
    ]
  }
}
