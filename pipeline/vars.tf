variable "name" {
  description = "The name of pipeline"
}
variable "build_project_name" {
  description = "The name of the build project"
}

variable "ClusterName" {
  description = "The name of cluster to use"
}
variable "ServiceName" {
  description = "The name of the service to use in the cluster"
}

variable "project_id" {
  description = "The id of the buildproject"
}
variable "bucket" {
  description = "artifact bucket"
}
variable "bucket_arn" {
  description = "artifact bucket arn"
}