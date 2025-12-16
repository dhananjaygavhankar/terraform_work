resource "azurerm_network_security_group" "main" {
  name                = "inbound-rules-nsg"
  location            = var.location_rg
  resource_group_name = var.rg_name

  security_rule {
    name                       = "all-allow"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

output "nsg_id" {
  value = azurerm_network_security_group.main.id
}