resource "random_integer" "cloudfront" {
  min     = 1
  max     = 8
}

resource "aws_cloudfront_distribution" "main" {
  enabled             = true
  is_ipv6_enabled     = true

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  origin {
    domain_name = aws_lb.lb.dns_name
    origin_id   = "alb-techpit-${random_integer.cloudfront.result}"

    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_keepalive_timeout = "5"
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = "60"
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "alb-techpit-${random_integer.cloudfront.result}"

    forwarded_values {
      query_string = true

      headers = [
        "CloudFront-Forwarded-Proto",
        "Host"
      ]
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 300
    default_ttl            = 300
    max_ttl                = 300
  }

  ordered_cache_behavior {
    path_pattern = "/wp-admin/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "alb-techpit-${random_integer.cloudfront.result}"

    forwarded_values {
      query_string = true

      headers = [
        "Authorization",
        "CloudFront-Forwarded-Proto",
        "Host"
      ]
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  ordered_cache_behavior {
    path_pattern = "wp-login.php"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "alb-techpit-${random_integer.cloudfront.result}"

    forwarded_values {
      query_string = true

      headers = [
        "Authorization",
        "CloudFront-Forwarded-Proto",
        "Host"
      ]
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  ordered_cache_behavior {
    path_pattern = "*.php"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "alb-techpit-${random_integer.cloudfront.result}"

    forwarded_values {
      query_string = true

      headers = [
        "Authorization",
        "CloudFront-Forwarded-Proto",
        "Host"
      ]
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }
}

output "cloudfront_dns_name" {
  value = aws_cloudfront_distribution.main.domain_name
}
