resource "azurerm_linux_virtual_machine" "ubuntu" {
  name                = "ubuntu-${local.name_suffix}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  size                = "Standard_D2ds_v4"
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.vm["ubuntu"].id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    name                 = "disk-ubuntu-${local.name_suffix}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "24.04.202610250"
  }

  depends_on = [
    azurerm_network_interface_security_group_association.vm
  ]
}

