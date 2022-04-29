module "S3" {
   source= "./s3"
}

terraform {
  backend "s3" {
    bucket = "fiap-trabalho"
    key    = "fiap-trabalho.tfstate"
    region = "us-east-1"
  }
}

module "alb" {
    source= "./loadbalancer"
}

module "instance" {
    source= "./instances"
}


