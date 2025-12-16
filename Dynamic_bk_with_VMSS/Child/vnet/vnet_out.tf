output "subnet_output_map" {
  description = "A map of subnet names to their IDs."
  value = { for s in azurerm_virtual_network.vnet.subnet: s.name => s.id }
}