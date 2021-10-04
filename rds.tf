resource "random_string" "sample" {
  length  = 10
  special = false
}

resource "aws_db_instance" "db" {
  identifier        = "aws-techpit-db"
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t3.micro"
  multi_az          = true

  name     = "techpit"
  username = "techpit"
  password = random_string.sample.result

  backup_retention_period = "7"
  backup_window           = "22:29-22:59"

  final_snapshot_identifier = "aws-techpit-db"

  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
  parameter_group_name   = aws_db_parameter_group.default.name
}

resource "aws_db_subnet_group" "db" {
  name       = "db"
  subnet_ids = ["${aws_subnet.private-a.id}", "${aws_subnet.private-b.id}"]
  tags = {
    Name = "aws-techpit-db"
  }
}

resource "aws_security_group" "db" {
  name        = "db"
  description = "Allow DB inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.allow.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_db"
  }
}

resource "aws_db_parameter_group" "default" {
  name   = "rds-pg"
  family = "mysql5.7"
}

output "db_endpoint" {
  value = aws_db_instance.db.endpoint
}

output "db_name" {
  value = aws_db_instance.db.name
}

output "db_user" {
  value = aws_db_instance.db.username
}

output "db_password" {
  value = aws_db_instance.db.password
}
