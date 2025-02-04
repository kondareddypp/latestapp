module "azure" {
  source = "../azure"

  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_network_name = var.virtual_network_name
  address_space       = var.address_space
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = var.vm_name
  resource_group_name = module.azure.resource_group_name
  location            = module.azure.location
  size                = var.vm_size
}
