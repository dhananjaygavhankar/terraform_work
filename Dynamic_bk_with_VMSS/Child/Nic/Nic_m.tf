

resource "azurerm_network_interface" "nic" {
  for_each            = var.subnets
  name                = "${each.value.name}-nic"
  location            = var.location_rg
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_output_map[each.value.name]
    # public_ip_address_id removed due to free tier restriction
  }
}



