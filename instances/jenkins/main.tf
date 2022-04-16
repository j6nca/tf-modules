resource "aws_instance" "jenkins" {
  ami           = var.ami # us-east-1
  instance_type = var.instance_type
  key_name      = var.key_pair
  availability_zone = "us-east-1a"

  security_groups = [aws_security_group.jenkins_sg.name]

  user_data = file("${path.module}/scripts/setup.sh")
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"

  vpc_id = var.vpc_id
  # below for debugging
  ingress{
    from_port = 8080
    protocol = "TCP"
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    from_port = 8443
    protocol = "TCP"
    to_port = 8443
    cidr_blocks = ["0.0.0.0/0"]
  }
  # opening ports 80 and 443 for http/s connections
  ingress{
    from_port = 80
    protocol = "TCP"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    from_port = 443
    protocol = "TCP"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    from_port = 22
    protocol = "TCP"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
