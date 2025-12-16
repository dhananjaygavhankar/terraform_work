# resource "azurerm_resource_group" "example" {
#   name     = "example-resources"
#   location = "West Europe"
# }

# resource "azurerm_virtual_network" "example" {
#   name                = "example-network"
#   resource_group_name = azurerm_resource_group.example.name
#   location            = azurerm_resource_group.example.location
#   address_space       = ["10.254.0.0/16"]
# }

# resource "azurerm_subnet" "example" {
#   name                 = "example"
#   resource_group_name  = azurerm_resource_group.example.name
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = ["10.254.0.0/24"]
# }

# resource "azurerm_public_ip" "example" {
#   name                = "example-pip"
#   resource_group_name = azurerm_resource_group.example.name
#   location            = azurerm_resource_group.example.location
#   allocation_method   = "Static"
# }

# since these variables are re-used - a locals block makes this more maintainable
# locals {
#   backend_address_pool_name      = "${azurerm_virtual_network.example.name}-beap"
#   frontend_port_name             = "${azurerm_virtual_network.example.name}-feport"
#   frontend_ip_configuration_name = "${azurerm_virtual_network.example.name}-feip"
#   http_setting_name              = "${azurerm_virtual_network.example.name}-be-htst"
#   listener_name                  = "${azurerm_virtual_network.example.name}-httplstn"
#   request_routing_rule_name      = "${azurerm_virtual_network.example.name}-rqrt"
#   redirect_configuration_name    = "${azurerm_virtual_network.example.name}-rdrcfg"
# }

resource "azurerm_application_gateway" "network" {
  name                = var.apgw_name
    resource_group_name = var.rg_nam
  location            = var.locatio

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = var.apgw_name
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = var.frontend_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = var.frontend_conf_name
    public_ip_address_id = var.apw_public_ip_id
  }

  backend_address_pool {
    name = var.Backend_pool_name
  }

  backend_http_settings {
    name                  = var.backend_set
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = var.listner_name
    frontend_ip_configuration_name = var.frontend_conf_name
    frontend_port_name             = var.frontend_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = var.backend_set
    priority                   = 110
    rule_type                  = "Basic"
    http_listener_name         = var.listner_name
    backend_address_pool_name  = var.Backend_pool_name
    backend_http_settings_name = var.backend_set
  }
}