# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED MODULE PARAMETERS
# These variables must be passed in by the operator.
# ----------------------------------------------------------------------------------------------------------------------
variable "name" {
  description = "The name of load balancer "
}

variable "vpc_id" {
  description = "The ID of the VPC in which to deploy the ELB."
}

variable "subnet_ids" {
  description = "The subnet IDs in which to deploy the ELB."
  type        = "list"
}

variable "health_check_path" {
  description = "The path on the instance the ELB can use for health checks."
}

variable "project_naam" {
  description = "The global project name"
}
# ----------------------------------------------------------------------------------------------------------------------
# OPTIONAL MODULE PARAMETERS
# These variables have defaults, but may be overridden by the operator.
# ----------------------------------------------------------------------------------------------------------------------
variable "sg_id" {
  description = "The security group id"
}

variable "port" {
  description = "The port on which targets receive traffic, unless overridden when registering a specific target. "
  default     = 80
}
variable "targed_type" {
  description = "The type of target that you must specify when registering targets with this target group."
  default     = "instance"
}

variable "protocol" {
  description = "The protocol to use for routing traffic to the targets. Should be one of \"TCP\", \"TLS\" , \"HTTP \" or \"HTTPS\"."
  default     = "HTTP"
}

variable "load_balancer_type" {
  description = "The type of load balancer to create. Possible values are application or network. The default value is application."
  default = "application"
}



