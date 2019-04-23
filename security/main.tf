
# ---------------------------------------------------------------------------------------------------------------------
# CREATE A SECURITY GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "ec2_security_group" {
  name        = "${var.name}"
  description = "Security group for the EC2 instances in the ECS cluster ${var.name}"
  vpc_id      = "${var.vpc_id}"


  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name    = "ecs_security_group"
    Project = "${var.project_naam}"
  }
}

resource "aws_security_group_rule" "all_outbound_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ec2_security_group.id}"
}

resource "aws_security_group_rule" "all_inbound_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ec2_security_group.id}"
}

resource "aws_security_group_rule" "all_inbound_ports" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ec2_security_group.id}"
}