resource "azurerm_windows_virtual_machine" "windows" {
  name                = "windows-${local.name_suffix}"
  computer_name       = "win-it3200"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  size                = "Standard_D2s_v4"
  admin_username      = var.admin_username
  admin_password      = var.windows_admin_password

  network_interface_ids = [
    azurerm_network_interface.vm["windows"].id
  ]

  os_disk {
    name                 = "disk-windows-${local.name_suffix}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "20348.5773.261025"
  }

  depends_on = [
    azurerm_network_interface_security_group_association.vm
  ]
}
