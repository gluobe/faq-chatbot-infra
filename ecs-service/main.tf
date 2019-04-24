# ---------------------------------------------------------------------------------------------------------------------
# IAM role for task definition
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "task-def-iam-role" {
  name = "${var.name}-task-aim-role"

  tags = {
    Name    = "task-def-iam-role"
    Project = "${var.project_naam}"
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecs_service_role" {
  name               = "${var.name}"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_service_role.json}"

  tags = {
    Name    = "ecs_service_role"
    Project = "${var.project_naam}"
  }
}

data "aws_iam_policy_document" "ecs_service_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "ecs_service_policy" {
  name   = "ecs-service-policy"
  role   = "${aws_iam_role.ecs_service_role.id}"
  policy = "${data.aws_iam_policy_document.ecs_service_policy.json}"
}

data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "ec2:Describe*",
      "ec2:AuthorizeSecurityGroupIngress",
    ]
  }
}

resource "aws_iam_role_policy_attachment" "attach" {
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
  role       = "${aws_iam_role.ecs_service_role.name}"
}
resource "aws_iam_role_policy_attachment" "s3poll" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role = "${aws_iam_role.ecs_service_role.id}"
}


# ---------------------------------------------------------------------------------------------------------------------
# task definition
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecs_task_definition" "task-def" {
  family                   = "${var.name}-task-def"
  requires_compatibilities = ["${var.requires_compatibilities}"]
  cpu                      = "${var.task_cpu}"
  memory                   = "${var.task_memory}"
  task_role_arn            = "${aws_iam_role.task-def-iam-role.arn}"
  execution_role_arn       = "arn:aws:iam::292242131230:role/ecsTaskExecutionRole"
  network_mode             = "${var.network_mode}"

  tags = {
    Name    = "task-def"
    Project = "${var.project_naam}"
  }

  container_definitions = <<DEFINITION
[
  {
    "name": "${var.container_name}",
    "image": "${var.image}",
    "essential": true,
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": ${var.containerPort},
        "hostPort":  ${var.hostPort}
      }]
  }
]
DEFINITION
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN ECS SERVICE
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.name}"
  cluster         = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.task-def.arn}"
  desired_count   = "${var.desired_count}"
  iam_role        = "${aws_iam_role.ecs_service_role.arn}"
  launch_type     = "${var.launch_type}"

  deployment_controller {
    type = "${var.deployment_controller}"
  }

  load_balancer {
    target_group_arn = "${var.elb_tg_arn}"
    container_name   = "${var.name}"
    container_port   = "${var.containerPort}"
  }
  depends_on = ["aws_iam_role_policy.ecs_service_policy","aws_ecs_task_definition.task-def"]
}