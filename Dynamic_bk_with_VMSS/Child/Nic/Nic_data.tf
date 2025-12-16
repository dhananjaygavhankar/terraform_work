data "azurerm_virtual_network" "Nic_vnet" {
  name                = var.vnet_name
  resource_group_name = var.rg_name

}