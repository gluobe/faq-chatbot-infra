# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED MODULE PARAMETERS
# These variables must be passed in by the operator.
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  description = "De naam van de ECS Cluster."
}

variable "max_size" {
  description = "The number of EC2 Instances to run in the ECS Cluster."
}

variable "min_size" {
  description = "The number of EC2 Instances to run in the ECS Cluster."
}

#
variable "instance_type" {
  description = "The type of EC2 Instance to deploy in the ECS Cluster (e.g. t2.micro)."
}

variable "vpc_id" {
  description = "The ID of the VPC in which to deploy the ECS Cluster."
}

variable "subnet_ids" {
  description = "The subnet IDs in which to deploy the EC2 Instances of the ECS Cluster."
  type        = "list"
}
variable "sg_id" {
  description = "The security group id"
}
variable "project_naam" {
  default     = "Faq-chatbot"
  description = "The global project name"
}

