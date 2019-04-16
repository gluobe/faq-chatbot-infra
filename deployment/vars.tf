variable "name" {
  description = "The name of the application."
}

variable "compute_platform" {
  description = "The compute platform can either be ECS, Lambda, or Server. Default is ECS."
}

variable "deployment_option" {
  description = "Indicates whether to route deployment traffic behind a load balancer. Valid Values are WITH_TRAFFIC_CONTROL or WITHOUT_TRAFFIC_CONTROL."
}

variable "deployment_type" {
  description = "Indicates whether to run an in-place deployment or a blue/green deployment. Valid Values are IN_PLACE or BLUE_GREEN."
}

variable "cluster_name" {
  description = "The naam of de ecs cluster"
}

variable "service_name" {
  description = "The naam of de ecs service"
}

variable "listener_arns" {
  description = "List of Amazon Resource Names (ARNs) of the load balancer listeners."
}

variable "target_group_name1" {
  description = "Name of the target group."
}

variable "target_group_name2" {
  description = "Name of the target group."
}

variable "project_naam" {
  default     = "Faq-chatbot"
  description = "The global project name"
}
