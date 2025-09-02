resource "azurerm_public_ip" "bastionip" {
  name                = var.bastion_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"

}
