# ---------------------------------------------------------------------------------------------------------------------
# CREATE A IAM ROLE
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "codebuild_iam_role" {
  name = "${var.name}"

  tags = {
    Name    = "codebuild_iam_role"
    Project = "${var.project_naam}"
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_iam_policy" {
  role = "${aws_iam_role.codebuild_iam_role.name}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:CompleteLayerUpload",
                "ecr:GetAuthorizationToken",
                "ecr:InitiateLayerUpload",
                "ecr:PutImage",
                "ecr:UploadLayerPart"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Sid": "CloudWatchLogsPolicy",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "CodeCommitPolicy",
            "Effect": "Allow",
            "Action": [
                "codecommit:GitPull"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "S3GetObjectPolicy",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "S3PutObjectPolicy",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "ECRPullPolicy",
            "Effect": "Allow",
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "ECRAuthPolicy",
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "buildpoll" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  role = "${aws_iam_role.codebuild_iam_role.id}"
}
resource "aws_iam_role_policy_attachment" "s3poll" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role = "${aws_iam_role.codebuild_iam_role.id}"
}
resource "aws_iam_role_policy_attachment" "poweruser" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  role = "${aws_iam_role.codebuild_iam_role.id}"
}
# ---------------------------------------------------------------------------------------------------------------------
# CREATE A CODEBUIKD PROJECT
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_codebuild_project" "codebuild_project" {
  name          = "${var.name}"
  build_timeout = "5"
  service_role  = "${aws_iam_role.codebuild_iam_role.arn}"

  tags = {
    Name    = "codebuild_project"
    Project = "${var.project_naam}"
  }
  cache {
    type     = "S3"
    location = "${var.bucket_location}"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/docker:18.09.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }
  source {
    type            = "CODEPIPELINE"
  }
  tags = {
    Name    = "VPC-faq-chatbot"
    Project = "${var.name}"
  }
}

