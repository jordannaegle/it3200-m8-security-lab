variable "subscription_id" {
  description = "Azure subscription in which to deploy the lab."
  type        = string
}

variable "location" {
  description = "Azure region for the lab resources."
  type        = string
  default     = "westus3"
}

variable "student_name" {
  description = "Student identifier used in resource names."
  type        = string
  default     = "jordan-naegle"
}

