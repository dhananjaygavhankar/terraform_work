# output "frontend_nic_id" {
#   value = azurerm_network_interface.nic["frontend_subnet"].id
#   description = "The NIC ID for the frontend subnet."
# }

# output "backend_nic_id" {
#   value = azurerm_network_interface.nic["backend_subnet"].id
#   description = "The NIC ID for the backend subnet."
# }

output "nic_ids" {
  value       = { for k, v in azurerm_network_interface.nic : k => v.id }
  description = "A map of NIC IDs for each subnet."
}