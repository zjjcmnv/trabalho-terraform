module "S3" {
   source= "./s3"
}

terraform {
  backend "s3" {
    bucket = "fiap-${terraform.workspace}"
    key    = "teste"
    region = "${var.aws_region}"
  }
}

module "alb" {
    source= "./loadbalancer"
}

module "instance" {
    source= "./instances"
}


