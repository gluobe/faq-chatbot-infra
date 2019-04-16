# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED MODULE PARAMETERS
# These variables must be passed in by the operator.
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  description = "De naam van de ecs service."
}

variable "launch_type" {
  description = "The launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2."
  default     = "EC2"
}

variable "deployment_controller" {
  description = "Configuration block containing deployment controller configuration. Valid values: CODE_DEPLOY, ECS."
  default     = "CODE_DEPLOY"
}

variable "scheduling_strategy" {
  description = "The scheduling strategy to use for the service. The valid values are REPLICA and DAEMON. Note that Fargate tasks do not support the DAEMON scheduling strategy."
  default     = "REPLICA"
}

# varss
variable "ecs_cluster_id" {
  description = "The ID of the ECS Cluster this ECS Service should run in."
}

variable "image" {
  description = "The Docker image to run in the ECS Task (e.g. foo/bar)."
}

variable "image_version" {
  description = "The version of the Docker image to run in the ECS Task. This is the the tag on the Docker image (e.g. latest or v3)."
}

variable "cpu" {
  description = "The number of CPU units to give the ECS Task, where 1024 represents one vCPU."
}

variable "memory" {
  description = "The amount of memory, in MB, to give the ECS Task."
}

variable "container_port" {
  description = "The port the Docker container in the ECS Task is listening on."
}

variable "host_port" {
  description = "The port on the host to map to var.container_port."
}

variable "desired_count" {
  description = "The number of ECS Tasks to run for this ECS Service."
}

variable "elb_tg_arn" {
  description = "The name of the ELB with which this ECS Service should register."
}

variable "task_def_arn" {
  description = "De naam van de task definition."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL MODULE PARAMETERS
# These variables have defaults, but may be overridden by the operator.
# ---------------------------------------------------------------------------------------------------------------------

variable "deployment_maximum_percent" {
  description = "The upper limit, as a percentage of var.desired_count, of the number of running ECS Tasks that can be running in a service during a deployment. Setting this to more than 100 means that during deployment, ECS will deploy new instances of a Task before undeploying the old ones."
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "The lower limit, as a percentage of var.desired_count, of the number of running ECS Tasks that must remain running and healthy in a service during a deployment. Setting this to less than 100 means that during deployment, ECS may undeploy old instances of a Task before deploying new ones."
  default     = 100
}

variable "project_naam" {
  default     = "Faq-chatbot"
  description = "The global project name"
}
