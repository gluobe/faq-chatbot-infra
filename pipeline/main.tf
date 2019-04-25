#-----------------------------------------------------------------------------------------------------------------------
# roles and policy
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "pipeline_iam_role" {
  name               = "${var.name}-pipeline_iam_role"
  assume_role_policy = "${data.aws_iam_policy_document.assume.json}"
}

data "aws_iam_policy_document" "assume" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = "${aws_iam_role.pipeline_iam_role.id}"
  policy_arn = "${aws_iam_policy.policy-pipeline.arn}"
}

resource "aws_iam_policy" "policy-pipeline" {
  name   = "policy"
  policy = "${data.aws_iam_policy_document.default.json}"
}

data "aws_iam_policy_document" "default" {
  statement {
    sid = ""

    actions = [
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "cloudwatch:*",
      "s3:*",
      "sns:*",
      "cloudformation:*",
      "rds:*",
      "sqs:*",
      "ecs:*",
      "iam:PassRole",
    ]

    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = "${aws_iam_role.pipeline_iam_role.id}"
  policy_arn = "${aws_iam_policy.s3.arn}"
}

resource "aws_iam_policy" "s3" {
  name   = "s3policy"
  policy = "${data.aws_iam_policy_document.s3.json}"
}

data "aws_iam_policy_document" "s3" {
  statement {
    sid = ""

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject",
    ]

    resources = [
      "${var.bucket_arn}",
      "${var.bucket_arn}/*",
    ]

    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = "${aws_iam_role.pipeline_iam_role.id}"
  policy_arn = "${aws_iam_policy.codebuild.arn}"
}

resource "aws_iam_policy" "codebuild" {
  name   = "codebuildpol"
  policy = "${data.aws_iam_policy_document.codebuild.json}"
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    sid = ""

    actions = [
      "codebuild:*",
    ]

    resources = ["${var.project_id}"]
    effect    = "Allow"
  }
}

#-----------------------------------------------------------------------------------------------------------------------
# create a code pipeline
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_codepipeline" "codepipeline" {
  name     = "${var.name}-pipeline"
  role_arn = "${aws_iam_role.pipeline_iam_role.arn}"

  artifact_store {
    location = "${var.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["code"]

      configuration = {
        OAuthToken = ""
        Owner      = "gluobe"
        Repo       = "faq-chatbot-app"
        Branch     = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["code"]
      output_artifacts = ["image"]
      version          = "1"

      configuration = {
        ProjectName = "${var.build_project_name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["image"]
      version         = "1"

      configuration {
        ClusterName = "${var.ClusterName}"
        ServiceName = "${var.ServiceName}"
        FileName    = "imagedefinitions.json"
      }
    }
  }
}
