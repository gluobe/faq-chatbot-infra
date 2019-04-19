output "ecr_url" {
  value = "${aws_ecr_repository.ecr.repository_url}"
}
output "s3_bucket_location" {
  value = "${aws_s3_bucket.codepipeline_bucket.bucket}"
}
output "s3_bucket_arn" {
  value = "${aws_s3_bucket.codepipeline_bucket.arn}"
}