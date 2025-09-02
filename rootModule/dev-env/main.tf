module "resource_group" {
  source              = "../../childModule/azurem_rg"
  resource_group_name = "rg-aurembastion"
  location            = "Central India"
}

module "virtual_network" {
  source               = "../../childModule/azurem_virtual_network"
  virtual_network_name = "vm-vnet"
  resource_group_name  = module.resource_group.resource_group_name_output
  location             = module.resource_group.location_output
  address_space        = "10.0.0.0/16"

  depends_on = [module.resource_group]

}

module "vmsubnet" {
  source               = "../../childModule/azurem_subnet"
  subnet_name          = "vm-subnet"
  resource_group_name  = module.resource_group.resource_group_name_output
  virtual_network_name = module.virtual_network.virtual_network_name_output
  address_prefixes     = "10.0.1.0/24"

  depends_on = [module.virtual_network]

}

module "bastion_subnet" {
  source               = "../../childModule/azurem_bastion_subnet"
  bastion_subnet_name  = "AzureBastionSubnet"
  resource_group_name  = module.resource_group.resource_group_name_output
  virtual_network_name = module.virtual_network.virtual_network_name_output
  address_prefixes     = "10.0.2.0/24"

  depends_on = [module.virtual_network]

}

module "bastion_ip" {
  source              = "../../childModule/azurem_bastion_publicip"
  resource_group_name = module.resource_group.resource_group_name_output
  location            = module.resource_group.location_output
  bastion_ip_name     = "bastion-ip"

  depends_on = [module.resource_group]

}

module "bastion_host" {
  source               = "../../childModule/azurem_bastion_host"
  bastion_host_name    = "bastion-host"
  resource_group_name  = module.resource_group.resource_group_name_output
  location             = module.resource_group.location_output
  bastion_subnet_id    = module.bastion_subnet.bastion_subnet_id
  bastion_public_ip_id = module.bastion_ip.bastion_ip_id

  depends_on = [module.bastion_subnet]

}

module "azure_key_vault" {
  source              = "../../childModule/azurem_key_vault"
  key_vault_name      = "myKeyVault890"
  resource_group_name = "testrgvault"
  secret_name         = "admin-password"
  depends_on          = [module.resource_group]

}

module "network_interface" {
  source              = "../../childModule/azurem_nic"
  nic_name            = "networkinterfacevm"
  location            = module.resource_group.location_output
  resource_group_name = module.resource_group.resource_group_name_output
  subnet_id           = module.vmsubnet.subnet_id

  depends_on = [module.vmsubnet]

}

module "virtual_machine" {
  source                = "../../childModule/azurem_virtual_machine"
  location              = module.resource_group.location_output
  resource_group_name   = module.resource_group.resource_group_name_output
  virtual_machine_name  = "virtualbastion"
  network_interface_ids = module.network_interface.nic_id_output
  admin_username        = "azureuser"
  admin_password        = module.azure_key_vault.secret_value

  depends_on = [module.azure_key_vault, module.network_interface]


}
