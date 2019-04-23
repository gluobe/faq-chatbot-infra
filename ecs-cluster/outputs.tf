output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.ecs_cluster.id}"
}

output "iam_role_id" {
  value = "${aws_iam_role.ecs_iam_role.id}"
}

output "iam_role_name" {
  value = "${aws_iam_role.ecs_iam_role.name}"
}

output "asg_name" {
  value = "${aws_autoscaling_group.ecs_autoscaling_group.name}"
}

output "cluster_name" {
  value = "${aws_ecs_cluster.ecs_cluster.name}"
}
