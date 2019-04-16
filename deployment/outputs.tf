output "dp-name" {
  value = "${aws_codedeploy_app.codedeploy-app.name}"
}

output "dpg-name" {
  value = "${aws_codedeploy_deployment_group.deplyment_group.deployment_group_name}"
}
