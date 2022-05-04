provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "fiap-trabalho"
    key    = "fiap-trabalho.tfstate"
    region = "us-east-1"
  }
}

module "instance" {
    source= "./instances"
}

