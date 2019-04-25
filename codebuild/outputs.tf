output "project_name" {
  value = "${aws_codebuild_project.codebuild_project.name}"
}

output "project_id" {
  value = "${aws_codebuild_project.codebuild_project.id}"
}
