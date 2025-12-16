
resource "azurerm_lb" "example" {
  name                = "TestLB"
  location            = var.location_rg
  resource_group_name = var.rg_name

  frontend_ip_configuration {
    name                 = var.LB_IP_Config
    public_ip_address_id = var.LB_pip
  }
} 

resource "azurerm_lb_backend_address_pool" "example" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "BackEndAddressPool"
}

# Associate each NIC with the backend pool
resource "azurerm_network_interface_backend_address_pool_association" "lb_assoc" {
  for_each                = var.nic_ids
  network_interface_id    = each.value
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
}

resource "azurerm_lb_probe" "example" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "ssh-running-probe"
  port            = 22
}

# Example LB rule for HTTP
resource "azurerm_lb_rule" "http" {
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = var.LB_IP_Config
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.example.id]
  probe_id                       = azurerm_lb_probe.example.id
}