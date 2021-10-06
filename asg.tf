resource "aws_launch_template" "wordpress" {
  image_id               = "ami-041b30207c70e0ebd"
  name_prefix            = "wordpress-"
  key_name               = "aws_development_common_ec2"
  instance_type          = "t3.small"
  vpc_security_group_ids = ["${aws_security_group.allow.id}"]

  instance_market_options {
    market_type = "spot"
  }
}

resource "aws_autoscaling_group" "wordpress" {
  name = "wordpress-asg-${aws_launch_template.wordpress.latest_version}"
  vpc_zone_identifier = ["${aws_subnet.public-a.id}", "${aws_subnet.public-b.id}"]

  min_size            = 2
  max_size            = 6

  health_check_type   = "ELB"
  target_group_arns   = ["${aws_lb_target_group.ec2.arn}"]

  launch_template {
    id      = aws_launch_template.wordpress.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "cpu" {
  autoscaling_group_name = aws_autoscaling_group.wordpress.name
  name                   = "cpu"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40.0
  }
}
