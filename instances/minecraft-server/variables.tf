variable "instance_type" {}
variable "ami" {}
variable "key_pair" {}
variable "hosted_zone_id" {}
variable "vpc_id" {}
variable "tcp_port" { default = 25565 }
variable "udp_port" { default = 19132 }