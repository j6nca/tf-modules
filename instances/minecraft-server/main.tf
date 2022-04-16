resource "aws_instance" "mc_server" {
  ami           = var.ami # us-east-1
  instance_type = var.instance_type
  key_name      = var.key_pair
  availability_zone = "us-east-1a"

  security_groups = [aws_security_group.mc_sg.name]

  # user_data = file("${path.module}/scripts/setup.sh")
}

resource "aws_security_group" "mc_sg" {
  name        = "mc_sg"

  vpc_id = var.vpc_id
  # below for debugging
  # minecraft ports
  ingress{
    from_port = var.tcp_port
    protocol = "TCP"
    to_port = var.tcp_port
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    from_port = var.udp_port
    protocol = "UDP"
    to_port = var.udp_port
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
