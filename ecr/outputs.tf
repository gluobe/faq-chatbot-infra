output "ecs_cluster_id" {
  value = "${aws_ecr_repository.ecr.repository_url}"
}
