resource "azurerm_network_security_group" "rules" {
name = var.name_NSG
 resource_group_name = var.rg_nam
  location            = var.locatio
  
dynamic "security_rule" {
  for_each = var.security_rules
   content {
name = security_rule.value.name
priority = security_rule.value.priority
direction = security_rule.value.direction
access = security_rule.value.access
protocol = security_rule.value.protocol
source_port_range = security_rule.value.source_port_range
destination_port_range = security_rule.value.destination_port_range
source_address_prefix = security_rule.value.source_address_prefix
destination_address_prefix = security_rule.value.destination_address_prefix
}
}
}

output "security_rule_id" {
  description = "The ID of the created network security rule."
  # value       = { for k in azurerm_network_security_group.rules.security_rule: k.name => k.id }
value       = azurerm_network_security_group.rules.id
}

