variable "admin_username" {
  description = "Administrator username for all three VMs."
  type        = string
  default     = "labadmin"
}

variable "ssh_public_key_path" {
  description = "Path to the public SSH key for Ubuntu and Kali."
  type        = string
  default     = "./lab_ssh.key.pub"
}

variable "windows_admin_password" {
  description = "Administrator password for the Windows VM."
  type        = string
  sensitive   = true
}

variable "allowed_source_cidr" {
  description = "Public IP address allowed to use SSH and RDP, in CIDR notation."
  type        = string
}
