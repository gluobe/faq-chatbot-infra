# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED MODULE PARAMETERS
# These variables must be passed in by the operator.
# ----------------------------------------------------------------------------------------------------------------------
variable "name" {
  description = "the name of the security group"
}

variable "vpc_id" {
  description = "The vpc id"
}

variable "project_naam" {
  description = "The projectname"
}
