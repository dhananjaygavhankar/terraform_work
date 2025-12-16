
module "resource_group" {
  source  = "../../child/rg"
  rg_name = var.Parent_prod_rg_name
  # rg_name1    = "Practice"
  location_rg = var.Parent_prod_location_rg
  # child Variable = Parent variable 
}

module "vnet" {
  depends_on  = [module.resource_group]
  source      = "../../child/vnet"
  vnet_name   = var.vnet_name
  location_rg = var.Parent_prod_location_rg
  rg_name     = var.Parent_prod_rg_name
  subnets     = var.subnets
}

module "nsg" {
  depends_on  = [module.resource_group]
  source      = "../../child/Nic/NSG"
  rg_name     = var.Parent_prod_rg_name
  location_rg = var.Parent_prod_location_rg
}

# NIC module for VM
module "nic" {
  depends_on        = [module.vnet, module.resource_group, module.pip]
  source            = "../../child/Nic"
  rg_name           = var.Parent_prod_rg_name
  location_rg       = var.Parent_prod_location_rg
  vnet_name         = var.vnet_name
  subnets           = var.subnets
  subnet_output_map = module.vnet.subnet_output_map
  # public_ip_address = module.pip.pip_id
}


# Frontend VM
module "vm" {
  depends_on     = [module.vnet, module.nic]
  for_each       = module.nic.nic_ids
  source         = "../../child/VM"
  vm_name        = var.subnets[each.key].name
  disc_name      = var.subnets[each.key].name
  rg_name        = var.Parent_prod_rg_name
  location_rg    = var.Parent_prod_location_rg
  admin_username = var.admin_username
  admin_password = var.admin_password
  # admin_username = data.azurerm_key_vault_secret.username.value
  # admin_password = data.azurerm_key_vault_secret.password.value
  # admin_ssh_public_key = tls_private_key.vmss_ssh.public_key_openssh
  image_publisher = var.image_publisher
  image_offer     = var.image_offer
  image_sku       = var.image_sku
  image_version   = var.image_version
  os_disk_type    = var.os_disk_type
  tags            = var.tags
  vm_size         = var.vm_size
  nic_id          = each.value
}

module "nsg_ass" {
  depends_on = [module.nic, module.nsg, module.vm]
  for_each   = module.nic.nic_ids
  source     = "../../child/VM/Nsg_ass"
  nic_id     = module.nic.nic_ids[each.key]
  nsg_id     = module.nsg.nsg_id
}

module "pip" {
  depends_on  = [module.resource_group]
  source      = "../../child/PIP"
  pip_name    = var.pip_name
  rg_name     = var.Parent_prod_rg_name
  location_rg = var.Parent_prod_location_rg
  subnets     = var.subnets
}

locals {
  pip_map     = module.pip.pip_id
  pip_keys    = sort(keys(local.pip_map))
  bastion_pip = local.pip_map[local.pip_keys[0]]
  LB_pip      = local.pip_map[local.pip_keys[1]]
  # AGW_pip     = local.pip_map[local.pip_keys[2]]
}

module "bastion" {
  depends_on                      = [module.vnet, module.resource_group, module.pip]
  source                          = "../../child/Bastion"
  rg_name                         = var.Parent_prod_rg_name
  location_rg                     = var.Parent_prod_location_rg
  vnet_name                       = var.vnet_name
  bastion_Pip_id                  = local.bastion_pip
  bastion_subnet_address_prefixes = var.bastion_subnet_address_prefixes
}

module "LB" {
  depends_on   = [module.vnet, module.resource_group, module.pip]
  source       = "../../child/LB"
  rg_name      = var.Parent_prod_rg_name
  location_rg  = var.Parent_prod_location_rg
  LB_pip       = local.LB_pip
  LB_IP_Config = var.LB_IP_Config
  nic_ids      = module.nic.nic_ids
  vnet_name    = var.vnet_name
}



























# # Backend VM
# module "backend_vm" {
#   depends_on           = [module.vnet, module.nic]
#   source               = "../../child/VM"
#   vm_name              = "backend-vm"
#   rg_name              = var.Parent_prod_rg_name
#   location_rg          = var.Parent_prod_location_rg
#   admin_username       = var.admin_username
#   admin_ssh_public_key = tls_private_key.vmss_ssh.public_key_openssh
#   image_publisher      = var.image_publisher
#   image_offer          = var.image_offer
#   image_sku            = var.image_sku
#   image_version        = var.image_version
#   os_disk_type         = var.os_disk_type
#   tags                 = var.tags
#   vm_size              = var.vm_size
#   nic_id               = module.nic.backend_nic_id
# }

