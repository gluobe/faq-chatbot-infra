output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "pbl_subnet_a_id" {
  value = "${aws_subnet.pbl_subnet_a.id}"
}

output "pbl_subnet_b_id" {
  value = "${aws_subnet.pbl_subnet_b.id}"
}

output "prv_subnet_a_id" {
  value = "${aws_subnet.prv_subnet_a.id}"
}

output "prv_subnet_b_id" {
  value = "${aws_subnet.prv_subnet_b.id}"
}
