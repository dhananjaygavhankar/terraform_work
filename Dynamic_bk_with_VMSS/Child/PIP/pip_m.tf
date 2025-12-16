resource "azurerm_public_ip" "pip" {
  for_each = var.subnets
  name                = "${each.value.name}-pip"
  resource_group_name = var.rg_name
  location            =var.location_rg
  allocation_method   = "Static"
}

output "pip_id" {
  value = { for s in azurerm_public_ip.pip: s.name => s.id }
   }




