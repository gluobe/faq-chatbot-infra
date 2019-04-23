# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN ELB
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_lb" "lb" {
  name               = "${var.name}-alb"
  subnets            = ["${var.subnet_ids}"]
  security_groups    = ["${var.sg_id}"]
  load_balancer_type = "application"


  enable_deletion_protection = false

  tags = {
    Name    = "lb"
    Project = "${var.project_naam}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A TARGET GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb_target_group" "elb-tg1" {
  name        = "${var.name}-target1"
  port        = "3000"
  protocol    = "HTTP"
  target_type = "${var.targed_type}"
  vpc_id      = "${var.vpc_id}"
  depends_on  = ["aws_lb.lb"]

   health_check {
    interval            = "60"
    path                = "${var.health_check_path}"
    port                = "3000"
    healthy_threshold   = "3"
    unhealthy_threshold = "3"
    timeout             = "5"
    protocol            = "HTTP"
  }
  tags = {
    Name    = "lb_tg1"
    Project = "${var.project_naam}"
  }
}

resource "aws_lb_target_group" "elb-tg2" {
  name        = "${var.name}-target2"
  port        = "3000"
  protocol    = "HTTP"
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
