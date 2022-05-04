# Specify the provider and access details
variable "project" {
  default = "fiap-lab"
}

data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.project}"
  }
}

data "aws_subnets" "all" {
  filter {
    name   = "tag:Tier"
    values = ["Public"]
  }
  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.vpc.id}"]
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.all.ids)
  id       = each.value
}

resource "random_shuffle" "random_subnet" {
  input        = [for s in data.aws_subnet.public : s.id]
  result_count = 1
}

module "alb" {
    source= "../loadbalancer"
    
    instance = aws_instance.web.*.id
    subnet_ids= data.aws_subnets.all.ids
    sgs= aws_security_group.allow-ssh.id
}


resource "aws_instance" "web" {
  instance_type = "t3.micro"
  ami           = "${lookup(var.aws_amis, var.aws_region)}"

  count = 2

  subnet_id              = "${random_shuffle.random_subnet.result[0]}"
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]
  key_name               = "${var.KEY_NAME}"

  connection {
    user        = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_KEY}")}"
    host = "${self.public_dns}"
  }

  tags = {
    Name = "${format("nginx-${terraform.workspace}-%03d", count.index + 1)}"
  }
}
