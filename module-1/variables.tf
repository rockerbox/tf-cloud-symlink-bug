variable "environment" {
  description = "The current deployment environment"
  type        = string
  default     = "Development"
}

variable "DOPPLER_TOKEN" {
  description = "Not used by this project, but set globally in our Terraform Cloud organization; defined only to disable the warning that Terraform Cloud will display if this didn't exist."
  type        = string
  default     = "dummy-value"
}
