# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED MODULE PARAMETERS
# These variables must be passed in by the operator.
# ----------------------------------------------------------------------------------------------------------------------
variable "requires_compatibilities" {
  description = "A set of launch types required by the task. The valid values are EC2 and FARGATE."
}
variable "containerPort" {
  description = "The port exposed on the container"
}

variable "hostPort" {
  description = "The port on your host"
}

variable "container_name" {
  description = "The name of the container"
}

variable "network_mode" {
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host."
}

variable "name" {
  description = "De naam van de ecs service."
}

variable "launch_type" {
  description = "The launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2."
}

variable "deployment_controller" {
  description = "Configuration block containing deployment controller configuration. Valid values: CODE_DEPLOY, ECS."
}

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
variable "desired_count" {
  description = "The number of ECS Tasks to run for this ECS Service."
}

variable "elb_tg_arn" {
  description = "The name of the ELB with which this ECS Service should register."
}
variable "project_naam" {
  description = "The global project name"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL MODULE PARAMETERS
# These variables have defaults, but may be overridden by the operator.
# ---------------------------------------------------------------------------------------------------------------------
variable "task_cpu" {
  description = "The number of cpu units used by the task."
  default     = "256"
}

variable "task_memory" {
  description = "The amount (in MiB) of memory used by the task."
  default     = "64"
}
variable "scheduling_strategy" {
  description = "The scheduling strategy to use for the service. The valid values are REPLICA and DAEMON. Note that Fargate tasks do not support the DAEMON scheduling strategy."
  default     = "REPLICA"
}