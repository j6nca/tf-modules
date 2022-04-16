resource "aws_route53_record" "jenkins" {
  zone_id = var.hosted_zone_id
  name    = "jenkins"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.jenkins.public_ip]
}