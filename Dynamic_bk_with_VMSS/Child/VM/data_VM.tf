# data "azurerm_key_vault" "vault" {
#   name                = "ldsfkdjtewodgi"
#   resource_group_name = "key_rg"
# }

# data "azurerm_key_vault_secret" "username" {
#   name         = "VMLogin"
#   key_vault_id = data.azurerm_key_vault.vault.id
# }

# data "azurerm_key_vault_secret" "password" {
#   name         = "VMcredential"
#   key_vault_id = data.azurerm_key_vault.vault.id
# }