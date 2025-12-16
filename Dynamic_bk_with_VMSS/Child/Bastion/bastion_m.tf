resource "azurerm_subnet" "main" {
name = "AzureBastionSubnet"
resource_group_name = var.rg_name
virtual_network_name = var.vnet_name
address_prefixes = var.bastion_subnet_address_prefixes
}

resource "azurerm_bastion_host" "main" {
name = "examplebastion"
location = var.location_rg
resource_group_name =var.rg_name

ip_configuration {
name = "configuration"
subnet_id = azurerm_subnet.main.id
public_ip_address_id = var.bastion_Pip_id
}
}