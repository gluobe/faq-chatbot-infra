variable "region" {
  description = "The region where to deploy this code (e.g. us-east-1)."
  default     = "eu-west-2"
}

variable "key_pair_name" {
  description = "The name of the Key Pair that can be used to SSH to each EC2 instance in the ECS cluster. Leave blank to not include a Key Pair."
  default     = ""
}

variable "project_naam" {
  default     = "Faq-chatbot"
  description = "The global project name"
}
