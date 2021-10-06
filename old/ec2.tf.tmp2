data "aws_ami" "wordpress" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-wordpress-5.7.2-2-linux-debian-10*"]
  }

  owners = ["679593333241"]
}

resource "aws_instance" "wordpress" {
  ami           = data.aws_ami.wordpress.id
  key_name      = "aws_development_common_ec2"
  instance_type = "t3.small"

  subnet_id              = aws_subnet.public-a.id
  vpc_security_group_ids = ["${aws_security_group.allow.id}"]
}

output "ec2_public_ip" {
  value = aws_instance.wordpress.public_ip
}
