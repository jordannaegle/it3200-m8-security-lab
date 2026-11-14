resource "azurerm_network_security_group" "vm" {
  for_each = local.vm_names

  name                = "nsg-${each.key}-${local.name_suffix}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  security_rule {
    name                       = "AllowAdminFromMyIP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = each.key == "windows" ? "3389" : "22"
    source_address_prefix      = var.allowed_source_cidr
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "vm" {
  for_each = local.vm_names

  network_interface_id      = azurerm_network_interface.vm[each.key].id
  network_security_group_id = azurerm_network_security_group.vm[each.key].id
}
