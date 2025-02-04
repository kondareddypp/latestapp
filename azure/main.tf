# Configure the Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Create a virtual network
resource "azurerm_virtual_network" "main" {
  name                = var.virtual_network_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

# Create a subnet
resource "azurerm_subnet" "main" {
  name                 = var.subnet_name
  resource_group_name = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnet_address_prefixes
}

# Create a network interface
resource "azurerm_network_interface" "main" {
  name                = var.network_interface_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = var.private_ip_address_allocation
  }
}

# Create a virtual machine
resource "azurerm_linux_virtual_machine" "main" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  size                = var.vm_size

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_publisher
    offer     = var.source_image_offer
    sku       = var.source_image_sku
    version   = var.source_image_version
  }

  admin_username = var.admin_username
  ssh_key {
    path = var.ssh_public_key_path
  }
}
