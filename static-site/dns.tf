resource "aws_route53_record" "simple_site" {
  zone_id = var.hosted_zone_id
  name    = "jng.sh"
  type    = "A"
  alias {
    # for some reason it just uses a generic value here
    # name                   = aws_s3_bucket.site.website_endpoint
    # name                   = "s3-website-us-east-1.amazonaws.com"
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    # zone_id                = aws_s3_bucket.site.hosted_zone_id
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "subdomain_simple_site" {
  zone_id = var.hosted_zone_id
  name    = "www"
  type    = "A"
  alias {
    # for some reason it just uses a generic value here
    # name                   = aws_s3_bucket.site.website_endpoint
    # name                   = "s3-website-us-east-1.amazonaws.com"
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    # zone_id                = aws_s3_bucket.site.hosted_zone_id
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}