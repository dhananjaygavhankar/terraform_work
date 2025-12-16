resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location_rg
  resource_group_name = var.rg_name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  
  dynamic "subnet" {
    for_each = var.subnets
    content {
      name            = subnet.value.name
      address_prefixes = [subnet.value.cidr]
    }
  }
}


# subnet_id = [for s in azurerm_virtual_network.vnet.subnet : s.id if s.name == each.value.name][0]

# resource "azurerm_network_interface" "nic" {
#   # Dynamically creates a NIC for each item in the map
#   for_each            = var.subnets
#   name                = "${each.value.name}-nic"
#   location            = var.location_rg
#   resource_group_name = var.rg_name

#   ip_configuration {
#     name                          = "ipconfig1"
#     private_ip_address_allocation = "Dynamic"
#     # References the dynamically created subnet using the map key
#     # subnet_id = azurerm_virtual_network.vnet.subnet[each.key].id
#     subnet_id = [for s in azurerm_virtual_network.vnet.subnet : s.id if s.name == each.value.name][0]
#   }
# }













