# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN ELB
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_lb" "lb" {
  name                       = "${var.name}-lb"
  subnets                    = ["${var.subnet_ids}"]
  security_groups            = ["${var.sg_id}"]
  load_balancer_type         = "${var.load_balancer_type}"
  enable_deletion_protection = false

  tags = {
    Name    = "load balancers"
    Project = "${var.project_naam}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A TARGET GROUP
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_lb_target_group" "lb-tg" {
  name        = "${var.name}-target-1"
  port        = "${var.port}"
  protocol    = "HTTP"
  target_type = "${var.targed_type}"
  vpc_id      = "${var.vpc_id}"
  depends_on  = ["aws_lb.lb"]

  health_check {
    interval            = "60"
    path                = "${var.health_check_path}"
    port                = "${var.port}"
    healthy_threshold   = "3"
    unhealthy_threshold = "3"
    timeout             = "5"
    protocol            = "HTTP"
    matcher             = "200"
  }

  tags = {
    Name    = "load balancers targed group 1"
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
    target_group_arn = "${aws_lb_target_group.lb-tg.arn}"
  }
}

resource "aws_lb_listener" "lb_listner2" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.lb-tg.arn}"
  }
}
