output "public_ips" {
  description = "Public IP addresses of the lab VMs."
  value       = module.security_lab.public_ips
}

output "resource_group_name" {
  description = "Resource group containing the lab."
  value       = module.security_lab.resource_group_name
}
