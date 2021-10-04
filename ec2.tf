data "aws_ami" "wordpress" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-wordpress-5.7.2-2-linux-debian-10*"]
  }

  owners = ["679593333241"]
}

resource "aws_instance" "wordpress" {
  ami                    = data.aws_ami.wordpress.id
  instance_type          = "t3.small"
  vpc_security_group_ids = ["${aws_security_group.http.id}"]
}

resource "aws_security_group" "http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

output "public_ip" {
  value = aws_instance.wordpress.public_ip
}
