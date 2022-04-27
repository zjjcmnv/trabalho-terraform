output "elb_public" {
  value = "${aws_elb.web.dns_name}"
}
