backend_instance_count = 1

# Standard_F2s_v2, Standard_D2ls_v6
pip_name                = "host-ip-prod"
Parent_prod_location_rg = "centralindia"
Parent_prod_rg_name     = "dyanamic-rg"
vnet_name               = "dynamic-vnet"
vm_size                 = "Standard_B1s" #""Standard_B1s",Standard_F2s_v2, Standard_B1ls, Standard_F1s"
instance_count          = 1

image_publisher         = "Canonical"
image_offer             = "UbuntuServer"
image_sku               = "18.04-LTS"
image_version           = "latest"
os_disk_type            = "Standard_LRS"
upgrade_mode            = "Manual"
computer_name_prefix    = "prodvmss"
tags = {
  environment = "production"
}

subnets = {
  frontend_subnet1 = {
    name = "frontend1"
    cidr = "10.0.1.0/24"
  }
  frontend_subnet2 = {
    name = "frontend2"
    cidr = "10.0.2.0/24"
  }
  # frontend_subnet3 = {
  #   name = "frontend3"
  #   cidr = "10.0.3.0/24"
  # }
}

LB_IP_Config                    = "LB_IP_config"
bastion_subnet_address_prefixes = ["10.0.4.0/27"]
 