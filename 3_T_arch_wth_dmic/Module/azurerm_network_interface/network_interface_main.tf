# resource "azurerm_network_interface" "for_each" {
#   name                = var.name_nic
#   location            = var.locatio
#   resource_group_name = var.rg_nam

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = var.subne_id
#     private_ip_address_allocation = "Dynamic"
#   }
# }
resource "azurerm_network_interface" "for_each" {
  name                = var.name_nic
  location            = var.locatio
  resource_group_name = var.rg_nam

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subne_id
    
    # Uses the variable defined in 2A
    private_ip_address_allocation = var.private_ip_allocation_method
    
    # Uses the variable defined in 2A
    public_ip_address_id          = var.public_ip_resource_id
  }
}
    
output "Nic_id" {
  description = "The Nic-ID of the created network interface card."
  value       = azurerm_network_interface.for_each.id
}