locals {
  name_suffix = "uvu-it3200-${var.student_name}"
  vm_names    = toset(["ubuntu", "windows", "kali"])
}

resource "azurerm_resource_group" "lab" {
  name     = "rg-${local.name_suffix}"
  location = var.location

  tags = {
    course  = "IT3200"
    student = var.student_name
    purpose = "security-lab"
  }
}

resource "azurerm_virtual_network" "lab" {
  name                = "vnet-${local.name_suffix}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = ["10.32.0.0/16"]
}

resource "azurerm_subnet" "lab" {
  name                 = "subnet-${local.name_suffix}"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.32.1.0/24"]
}
