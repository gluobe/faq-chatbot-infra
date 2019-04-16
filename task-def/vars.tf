variable "name" {
  description = "De naam van de Task definition."
}

variable "requires_compatibilities" {
  description = "A set of launch types required by the task. The valid values are EC2 and FARGATE."
  default     = "FARGATE"
}

variable "task_cpu" {
  description = "The number of cpu units used by the task."
  default     = "256"
}

variable "task_memory" {
  description = "The amount (in MiB) of memory used by the task."
  default     = "64"
}

variable "containerPort" {
  description = "The port exposed on the container"
  default     = 80
}

variable "hostPort" {
  description = "The port on your host"
  default     = 80
}

variable "container_name" {
  description = "The name of the container"
}

variable "image" {
  description = "The image to use (ex: repository-url/image:tag)"
}

variable "network_mode" {
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host."
  default     = "host"
}

variable "project_naam" {
  default     = "Faq-chatbot"
  description = "The global project name"
}
