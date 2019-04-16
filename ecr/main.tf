resource "aws_ecr_repository" "ecr" {
  name = "${var.name}"

  tags = {
    Name    = "ecr"
    Project = "${var.project_naam}"
  }
}
