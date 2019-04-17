output "ecs_codebuild_id" {
  value = "${aws_codebuild_project.codebuild_project.id}"
}
output "project_name" {
  value = "${aws_codebuild_project.codebuild_project.name}"
}
