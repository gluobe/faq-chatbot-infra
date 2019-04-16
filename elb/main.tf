# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN ELB
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb" "lb" {
  name               = "${var.name}-lb"
  internal           = false
  subnets            = ["${var.subnet_ids}"]
  security_groups    = ["${aws_security_group.lb_sg.id}"]
  load_balancer_type = "application"

  enable_deletion_protection = false

  tags = {
    Name    = "lb"
    Project = "${var.project_naam}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A SECURITY GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "lb_sg" {
  name        = "${var.name}"
  description = "The security group for the ${var.name} ELB"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "80"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "lb_sg"
    Project = "${var.project_naam}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A TARGET GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb_target_group" "elb-tg1" {
  name        = "${var.name}-target1"
  port        = "8080"
  protocol    = "HTTP"
  target_type = "${var.targed_type}"
  vpc_id      = "${var.vpc_id}"
  depends_on  = ["aws_lb.lb"]

  tags = {
    Name    = "lb_tg1"
    Project = "${var.project_naam}"
  }
}

resource "aws_lb_target_group" "elb-tg2" {
  name        = "${var.name}-target2"
  port        = "${var.port}"
  protocol    = "${var.protocol}"
  target_type = "${var.targed_type}"
  vpc_id      = "${var.vpc_id}"
  depends_on  = ["aws_lb.lb"]

  tags = {
    Name    = "lb_tg2"
    Project = "${var.project_naam}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A LISTENER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb_listener" "lb_listner1" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.elb-tg1.arn}"
  }
}

resource "aws_lb_listener" "lb_listner2" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.elb-tg2.arn}"
  }
}
