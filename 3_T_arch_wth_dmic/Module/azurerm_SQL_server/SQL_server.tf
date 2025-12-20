resource "azurerm_mssql_server" "main" {
  name                         = var.SQL_server
  resource_group_name          = var.rg_nam
  location                     = var.locatio
  version                      = "12.0"
  administrator_login          = "missadministrator"
  administrator_login_password = "thisIsKat11"
  minimum_tls_version          = "1.2"

#   azuread_administrator {
#     login_username = "AzureAD Admin"
#     object_id      = "00000000-0000-0000-0000-000000000000"
#   }
}

resource "azurerm_mssql_database" "db" {
    depends_on = [ azurerm_mssql_server.main ]
  name      = azurerm_mssql_server.main.name
  server_id = azurerm_mssql_server.main.id
}