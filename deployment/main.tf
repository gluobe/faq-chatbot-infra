#-----------------------------------------------------------------------------------------------------------------------
#               deploy-app
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_codedeploy_app" "codedeploy-app" {
  compute_platform = "${var.compute_platform}"
  name             = "${var.name}-app"
}

#-----------------------------------------------------------------------------------------------------------------------
#               deployment group
#-----------------------------------------------------------------------------------------------------------------------
#--------------------------------------------AIM-role-------------------------------------------------------------------
resource "aws_iam_role" "codedeploy-iam-role" {
  name = "${var.name}-dpg-role"

  tags = {
    Name    = "codedeploy-iam-role"
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
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}

EOF
}

#----------------------------------------policy-attachment--------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = "${aws_iam_role.codedeploy-iam-role.name}"
}

resource "aws_iam_role_policy" "awscodedeployecsPol" {
  name = "test_policy"
  role = "${aws_iam_role.codedeploy-iam-role.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ecs:DescribeServices",
                "ecs:CreateTaskSet",
                "ecs:UpdateServicePrimaryTaskSet",
                "ecs:DeleteTaskSet",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:DescribeRules",
                "elasticloadbalancing:ModifyRule",
                "lambda:InvokeFunction",
                "cloudwatch:DescribeAlarms",
                "sns:Publish",
                "s3:GetObject",
                "s3:GetObjectMetadata",
                "s3:GetObjectVersion"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}

EOF
}
#-----------------------------------------------------------------------------------------------------------------------
# SNS topic
#-----------------------------------------------------------------------------------------------------------------------
/*
resource "aws_sns_topic" "deploymenttopic" {
  name = "pipeline-deployment"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}
*/
# ---------------------------------------------------------------------------------------------------------------------
# CREATE A DEPLOYMENT GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_codedeploy_deployment_group" "deplyment_group" {
  app_name               = "${aws_codedeploy_app.codedeploy-app.name}"
  deployment_group_name  = "${var.name}-deployment-group"
  service_role_arn       = "${aws_iam_role.codedeploy-iam-role.arn}"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "${var.deployment_option}"
    deployment_type   = "${var.deployment_type  }"
  }

  ecs_service {
    cluster_name = "${var.cluster_name}"
    service_name = "${var.service_name}"
  }
/*
  trigger_configuration {
    trigger_events = ["DeploymentStart"]
    trigger_name = "pipeline trigger"
    trigger_target_arn = "${aws_sns_topic.deploymenttopic.arn}"
  }
*/
  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = ["${var.listener_arns}"]
      }

      target_group {
        name = "${var.target_group_name1}"
      }

      target_group {
        name = "${var.target_group_name2}"
      }
    }
  }
}
