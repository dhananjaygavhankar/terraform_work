
resource "azurerm_virtual_network" "for_each" {
  # for_each = var.nic
  name                = var.vnet_name
   location            = var.locatio
  resource_group_name = var.rg_nam
  address_space       = var.address
  dns_servers         = var.dns

    dynamic "subnet" {
      for_each = var.subnets
      content {
    name             = subnet.value.name
    address_prefixes = subnet.value.subnet_address
  }
  }
}

output "subnet_ids"{
  value = {for sub in azurerm_virtual_network.for_each.subnet: sub.name => sub.id}
}