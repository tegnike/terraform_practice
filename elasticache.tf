resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = "memcached"
  engine               = "memcached"
  engine_version       = "1.5.16"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.5"
  port                 = 11211
  subnet_group_name    = aws_elasticache_subnet_group.default.name
  security_group_ids   = ["${aws_security_group.memcached.id}"]
}

resource "aws_elasticache_subnet_group" "default" {
  name       = "memcached-cache-subnet"
  subnet_ids = ["${aws_subnet.private-a.id}", "${aws_subnet.private-b.id}"]
}

resource "aws_security_group" "memcached" {
  name        = "memcached"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "allow_memcached"
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    security_groups = ["${aws_security_group.allow.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_memcached"
  }
}

output "elasticache_dns_name" {
  value = aws_elasticache_cluster.memcached.configuration_endpoint
}
