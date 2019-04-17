resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.name}-bucket"
  acl    = "private"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "${var.name}-pipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = "${aws_iam_role.codepipeline_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.name}-pipeline"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.codepipeline_bucket.bucket}"
    type     = "S3"


  }

  stage {
    name = "Source"

    action {
      name             = "${var.name}-Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["${var.name}_source_output"]


      configuration = {
        OAuthToken  = "bb36d8e68ac75f186eae44731ff75cdfdfbcc750"
        Owner  = "gluobe"
        Repo   = "faq-chatbot-app"
        Branch = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "${var.name}-Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["${var.name}_source_output"]
      output_artifacts = ["${var.name}_build_output"]
      version         = "1"

      configuration = {
        ProjectName = "${var.build_project_name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "ECS"
      input_artifacts  = ["${var.name}_build_output"]
      version          = "1"

      configuration {
        ClusterName = "${var.ClusterName}"
        ServiceName = "${var.ServiceName}"
        FileName = "imagedefinitions.json"
      }
    }
  }
}