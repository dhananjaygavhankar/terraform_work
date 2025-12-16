resource "azurerm_public_ip" "for_each" {
  name                = var.name_pip
  resource_group_name = var.rg_nam
  location            = var.locatio
  allocation_method   = "Static"
  zones               = ["1", "2", "3"]
#   tags = {
#     environment = "Production"
#   }
}

output "Public_Ips_to_use"{
  value = azurerm_public_ip.for_each.id
}
