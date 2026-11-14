variable "location" {
  description = "Azure region for the lab."
  type        = string
}

variable "student_name" {
  description = "Student identifier used in resource names."
  type        = string
}

variable "admin_username" {
  description = "Administrator username for the VMs."
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH key for the Linux VMs."
  type        = string
}

variable "windows_admin_password" {
  description = "Administrator password for the Windows VM."
  type        = string
  sensitive   = true
}

variable "allowed_source_cidr" {
  description = "Source IP range permitted to use SSH and RDP."
  type        = string
}
