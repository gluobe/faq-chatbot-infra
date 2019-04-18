# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN ECS CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.name}"

  tags = {
    Name    = "ecr_cluster"
    Project = "${var.project_naam}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY AN AUTO SCALING GROUP (ASG)
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name                 = "${var.name}"
  min_size             = "${var.min_size}"
  max_size             = "${var.max_size}"
  launch_configuration = "${aws_launch_configuration.ecs_launch_config.name}"
  vpc_zone_identifier  = ["${var.subnet_ids}"]

}

# ---------------------------------------------------------------------------------------------------------------------
# AMI
# ---------------------------------------------------------------------------------------------------------------------
data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized"]
  }

  tags = {
    Name    = "ecs_ami"
    Project = "${var.project_naam}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# launch configuration
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_launch_configuration" "ecs_launch_config" {
  name                 = "${var.name}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_pair_name}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_iam_instance_profile.name}"
  security_groups      = ["${aws_security_group.ecs_security_group.id}"]
  image_id             = "${data.aws_ami.ecs_ami.id}"

  user_data = <<EOF
#!/bin/bash
echo "ECS_CLUSTER=${var.name}" >> /etc/ecs/ecs.config
EOF

  lifecycle {
    create_before_destroy = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN IAM ROLE FOR EACH INSTANCE IN THE CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "ecs_iam_role" {
  name               = "${var.name}"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_policy_doc.json}"

  # aws_iam_instance_profile.ecs_instance sets create_before_destroy to true, which means every resource it depends on,
  # including this one, must also set the create_before_destroy flag to true, or you'll get a cyclic dependency error.
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name    = "ecs_iam_role"
    Project = "${var.project_naam}"
  }
}

data "aws_iam_policy_document" "ecs_policy_doc" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "ecs_iam_instance_profile" {
  name = "${var.name}"
  role = "${aws_iam_role.ecs_iam_role.name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "ecs_cluster_permissions" {
  name   = "ecs-cluster-permissions"
  role   = "${aws_iam_role.ecs_iam_role.id}"
  policy = "${data.aws_iam_policy_document.ecs_cluster_permissions.json}"
}

data "aws_iam_policy_document" "ecs_cluster_permissions" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:UpdateContainerInstancesState",
      "ecs:Submit*",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

resource "aws_iam_role_policy" "ecs_StartTask_permissions" {
  name   = "ecs-StartTask-permissions"
  role   = "${aws_iam_role.ecs_iam_role.id}"
  policy = "${data.aws_iam_policy_document.ecs_StartTask_permissions.json}"
}

data "aws_iam_policy_document" "ecs_StartTask_permissions" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    sid       = "VisualEditor0"
    actions   = ["ecs:StartTask"]
  }
}
resource "aws_iam_role_policy_attachment" "s3poll" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role = "${aws_iam_role.ecs_iam_role.id}"
}
resource "aws_security_group" "ecs_security_group" {
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
  security_group_id = "${aws_security_group.ecs_security_group.id}"
}

resource "aws_security_group_rule" "all_inbound_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ecs_security_group.id}"
}

resource "aws_security_group_rule" "all_inbound_ports" {
  count = "${length(var.allow_inbound_ports_and_cidr_blocks)}"

  type              = "ingress"
  from_port         = "${element(keys(var.allow_inbound_ports_and_cidr_blocks), count.index)}"
  to_port           = "${element(keys(var.allow_inbound_ports_and_cidr_blocks), count.index)}"
  protocol          = "tcp"
  cidr_blocks       = ["${lookup(var.allow_inbound_ports_and_cidr_blocks, element(keys(var.allow_inbound_ports_and_cidr_blocks), count.index))}"]
  security_group_id = "${aws_security_group.ecs_security_group.id}"
}