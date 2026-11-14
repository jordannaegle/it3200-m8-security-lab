output "public_ips" {
  description = "Public IP addresses of the three lab VMs."
  value = {
    for name, ip in azurerm_public_ip.vm : name => ip.ip_address
  }
}

output "resource_group_name" {
  description = "Resource group containing the lab."
  value       = azurerm_resource_group.lab.name
}
