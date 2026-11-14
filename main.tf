module "security_lab" {
  source = "./modules/security_lab"

  location               = var.location
  student_name           = var.student_name
  admin_username         = var.admin_username
  ssh_public_key         = file(pathexpand(var.ssh_public_key_path))
  windows_admin_password = var.windows_admin_password
  allowed_source_cidr    = var.allowed_source_cidr
}
