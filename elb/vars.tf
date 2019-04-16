# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED MODULE PARAMETERS
# These variables must be passed in by the operator.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "De naam van de elastic load balancer "
}

#andere var

variable "vpc_id" {
  description = "The ID of the VPC in which to deploy the ELB."
}

variable "subnet_ids" {
  description = "The subnet IDs in which to deploy the ELB."
  type        = "list"
}

variable "instance_port" {
  description = "The port the EC2 Instance is listening on. The ELB will route traffic to this port."
}

variable "health_check_path" {
  description = "The path on the instance the ELB can use for health checks. Do NOT include a leading slash."
}

variable "targed_type" {
  description = "The type of target that you must specify when registering targets with this target group."
  default     = "instance"
}

variable "protocol" {
  description = "The protocol to use for routing traffic to the targets. Should be one of \"TCP\", \"TLS\" , \"HTTP \" or \"HTTPS\"."
  default     = "HTTP"
}

variable "port" {
  description = "The port on which targets receive traffic, unless overridden when registering a specific target. "
  default     = 80
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL MODULE PARAMETERS
# These variables have defaults, but may be overridden by the operator.
# ---------------------------------------------------------------------------------------------------------------------

variable "lb_port" {
  description = "The port the ELB listens on."
  default     = 80
}

variable "project_naam" {
  default     = "Faq-chatbot"
  description = "The global project name"
}
