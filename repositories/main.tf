resource "aws_ecr_repository" "ecr" {
  name = "${var.name}"

  tags = {
    Name    = "ecr"
    Project = "${var.project_naam}"
  }
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.name}-bucket"
  acl    = "private"
}