resource "aws_route53_record" "mc" {
  zone_id = var.hosted_zone_id
  name    = "mc"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.mc_server.public_ip]
}