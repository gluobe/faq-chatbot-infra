# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED MODULE PARAMETERS
# These variables must be passed in by the operator.
# ----------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "De naam van de buildproject."
}

variable "project_naam" {
  description = "The global project name"
}

variable "bucket_location" {
  description = "The location of the bucket to cash the build"
}
