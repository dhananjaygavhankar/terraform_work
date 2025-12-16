#============================================================================================
# 🚀 Optimized main.tf Configuration 🚀
#============================================================================================

# Consolidate all core variables and calculated values into a single locals block.
locals {
  # 1. Configuration: Defines which subnets require a Public IP
  required_pip_subnets = toset(["Application_gateway", "AzureBastionSubnet", "Frontend"]) #"Frontend"


  # 2. Filter: Creates a map of Subnet IDs that require a Public IP (pip_requirement)
  pip_requirement = {
    for key, id in module.Virtual_network.subnet_ids : key => id
    if contains(local.required_pip_subnets, key)
  }
  # 3. Count: Determines how many Public IPs to create
  pip_count = length(local.pip_requirement)

  # 4. Map Keys: Get sorted list of subnet names requiring IPs (for index correlation)
  required_subnet_names_sorted = sort(keys(local.pip_requirement))

  # # 5. List of Public IP IDs: Directly reference the module's ID output
  # #    Assumes module.public_ip.public_ip_ids is now the correct output.
  # available_ip_ids = module.public_ip.public_ip_ids

  available_ip_ids = flatten([
    for m in module.public_ip : m.Public_Ips_to_use
  ])

  # 6. Final Mapping: Correlate Subnet Name (Key) to Public IP ID (Value)
  subnet_to_public_ip_map = {
    for index, subnet_name in local.required_subnet_names_sorted :
    subnet_name => element(local.available_ip_ids, index)
  }




  VM_cretated_for = toset(["Frontend", "Backend"])
  VM_requirement = {
    for key, v in module.Network_interface : key => v.Nic_id
    if contains(["Frontend", "Backend"], key)
  }
  VM_required = sort(keys(local.VM_requirement))

}


# ----------------------------------------------------------------------------
## 📤 Outputs (Consolidated and Cleaned)
# ----------------------------------------------------------------------------

output "subn_id" {
  depends_on  = [module.Virtual_network]
  description = "Map of all VNet subnets and their IDs."
  value       = module.Virtual_network.subnet_ids
}

output "public_IP_required_for" {
  description = "Map of subnets explicitly flagged to receive a Public IP."
  value       = local.pip_requirement
}

output "subnet_ip_mapping" {
  description = "Final map correlating required subnet names to their allocated Public IP Resource IDs."
  value       = local.subnet_to_public_ip_map
}

output "network_security_rule_id" {
  depends_on  = [module.NSG]
  description = "The NSG ID of the created network security rule."
  # value = {
  #   for k, v in module.NSG : k => v.security_rule_id
  # }
  value = module.NSG.security_rule_id
}

output "network_interface_id" {
  depends_on  = [module.Network_interface]
  description = "The NIC ID of the created network security rule."
  value = {
    for k, v in module.Network_interface : k => v.Nic_id
  }

}

# ----------------------------------------------------------------------------
## 🧱 Resource Group (RG)
# ----------------------------------------------------------------------------
module "resource_group" {
  source   = "../../module/azurerm_resource_group"
  for_each = toset(var.Project.resource_group.rg1)
  rg_nam   = each.value
  locatio  = var.Project.resource_group.Location
}

# ----------------------------------------------------------------------------
## 🌐 Virtual Network (VNet)
# ----------------------------------------------------------------------------
module "Virtual_network" {
  # Implicit dependency on module.resource_group via rg_nam/locatio access is usually sufficient, 
  # but explicit depends_on is fine if modules are complex.
  depends_on = [module.resource_group]
  source     = "../../module/azurerm_virtual_network"
  vnet_name  = var.Project.virtual_network.vnet_name
  address    = var.Project.virtual_network.address
  dns        = var.Project.virtual_network.dns
  locatio    = var.Project.resource_group.Location
  rg_nam     = var.Project.resource_group.rg1[0]
  subnets    = var.Project.virtual_network.subnets
}

# ----------------------------------------------------------------------------
## 🔗 Public IP Address (PIP)
# ----------------------------------------------------------------------------
module "public_ip" {
  depends_on = [module.resource_group, module.Virtual_network]
  source     = "../../module/azurerm_public_ip"

  # Use the consolidated count local
  count = local.pip_count

  name_pip = "pip-${count.index}"
  rg_nam   = var.Project.resource_group.rg1[0]
  locatio  = var.Project.resource_group.Location
}

# ----------------------------------------------------------------------------
## 💻 Network Interface (NIC)
# ----------------------------------------------------------------------------
module "Network_interface" {
  depends_on = [module.public_ip, module.NSG]
  source     = "../../module/azurerm_network_interface"

  # Filter NIC creation to only 'frontend' and 'Backend' subnets
  for_each = {
    for key, id in module.Virtual_network.subnet_ids : key => id
    if contains(["Frontend", "Backend"], key)
  }

  name_nic = each.key
  rg_nam   = var.Project.resource_group.rg1[0]
  locatio  = var.Project.resource_group.Location
  subne_id = each.value

  # Use the final mapping local for conditional assignment
  public_ip_resource_id        = lookup(local.subnet_to_public_ip_map, each.key, null)
  private_ip_allocation_method = "Dynamic"
}

# ----------------------------------------------------------------------------
## 📤 Network security group for rules creation
# ----------------------------------------------------------------------------

module "NSG" {
  depends_on     = [module.resource_group]
  source         = "../../module/Network_security_rules"
  name_NSG       = "NSG_rules"
  security_rules = var.Project.for_each_rule
  rg_nam         = var.Project.resource_group.rg1[0]
  locatio        = var.Project.resource_group.Location

}


# ----------------------------------------------------------------------------
## 📤 Network interface interface association for NSG rules 
# ----------------------------------------------------------------------------
module "NSG_asso" {
  depends_on                = [module.Network_interface]
  source                    = "../../module/Asurerm_network_interface_security_ass"
  for_each                  = module.Network_interface
  network_interface_id      = each.value.Nic_id
  network_security_group_id = module.NSG.security_rule_id

}


# ----------------------------------------------------------------------------
## 📤 For Azurerm Virtual Machin Linux  
# ----------------------------------------------------------------------------
#_______________from Network Interface module____________________________________________________
output "for_vm" {
  value = {
    for k, v in module.Network_interface : k => v.Nic_id
  }
}
#_______________________________________________________________________________
#_______________from Virtual machine module_____________________________________
output "vm_id_present" {
  depends_on = [module.Virtual_machine]
  value = {
    for k, v in module.Virtual_machine : k => v.vm_ids
  }
}
#_________________________________________________________________________________
module "Virtual_machine" {
  depends_on = [module.Network_interface]
  source     = "../../module/azurerm_linux_virtual_machine"
  # for_each = {
  #   for k, v in module.Network_interface : k => v.Nic_id
  # }

  for_each = var.Project.virtual_machine
  name_vm  = "${each.key}-Vm"
  rg_nam   = var.Project.resource_group.rg1[0]
  locatio  = var.Project.resource_group.Location
  # Virtual_machine = var.Project.Virtual_machine[each.key]

  # Virtual_machine        = lookup(var.Project.Virtual_machine[each.key], each.key, null)
  size                   = each.value.size
  admin_username         = each.value.admin_username
  admin_password         = each.value.admin_password
  os_disk                = each.value.os_disk
  source_image_reference = each.value.source_image_reference
  network_interface_ids  = [module.Network_interface[each.key].Nic_id]
  custom_data            = base64encode(file(each.value.script_name))
}


# ----------------------------------------------------------------------------
## 📤 For Azurerm application gateway 
# ----------------------------------------------------------------------------
module "application_gateway" {
  source = "../../module/azurerm_application_gateway"
  for_each = {
    for key, id in module.Virtual_network.subnet_ids : key => id
    if contains(["Application_gateway"], key)
  }
  rg_nam            = var.Project.resource_group.rg1[0]
  locatio           = var.Project.resource_group.Location
  apgw_name         = var.Project.application_gateway.name
  subnet_id         = each.value
  Backend_pool_name = "Frontend-Vm"
  # Backend_pool_name  = element(module.Virtual_machine.vm_ids, 0)
  frontend_name      = var.Project.application_gateway.frontend_name
  apw_public_ip_id   = lookup(local.subnet_to_public_ip_map, each.key, null)
  frontend_conf_name = var.Project.application_gateway.frontend_conf_name
  listner_name       = var.Project.application_gateway.listner_name
  backend_set        = var.Project.application_gateway.backend_set
}



# #============================================================================================
# # =============     To create resource Group for landing zone.  ================
# #============================================================================================

# module "resource_group" {
#   source   = "../../module/azurerm_resource_group"
#   for_each = toset(var.Project.resource_group.rg1)
#   rg_nam   = each.value
#   locatio  = var.Project.resource_group.Location
# }


# #============================================================================================
# # =============     To create Virtual Networks for landing zone.  ================
# #============================================================================================


# module "Virtual_network" {
#   depends_on = [module.resource_group]
#   source     = "../../module/azurerm_virtual_network"
#   vnet_name  = var.Project.virtual_network.vnet_name
#   address    = var.Project.virtual_network.address
#   dns        = var.Project.virtual_network.dns
#   locatio    = var.Project.resource_group.Location
#   rg_nam     = var.Project.resource_group.rg1[0]
#   subnets    = var.Project.virtual_network.subnets
# }

# #============================================================================================
# # =============To find out no. subnet with respective ids for landing zone.  ================
# #============================================================================================
# output "subn_id" {
#   depends_on = [module.Virtual_network]
#   value      = module.Virtual_network.subnet_ids
# }

# #============================================================================================
# # =============     To find out no. of required Public Ip for landing zone.  ================
# #============================================================================================

# locals {
#   subnets              = module.Virtual_network.subnet_ids
#   required_nic_subnets = toset(["frontend", "AzureBastionSubnet"]) # Append subnet name for Ip requirements It will add no. of counts of IPs 
#   pip_requirement = {
#     for key, id in module.Virtual_network.subnet_ids : key => id
#     if contains(local.required_nic_subnets, key)
#   }
#   frontend_subnet_count = length(local.pip_requirement)
# }
# output "public_IP_required_for" {
#   value = local.pip_requirement
# }

# output "subnets_pip" {
#   depends_on = [module.Virtual_network]
#   value      = local.frontend_subnet_count
# }

# # map_keys_sorted = sort(keys(local.pip_requirement))

# #============================================================================================
# # =============     For Azurerm Network Interface for landing zone.  ================
# #============================================================================================

# module "public_ip" {
#   depends_on = [module.resource_group, module.Virtual_network]
#   source     = "../../module/azurerm_public_ip" #
#   # count      = 1  #____No. of required Public Ips for Respective Landing Zone _________
#   count    = local.frontend_subnet_count         #_____Fetch count from locals________     
#   name_pip = "pip-${count.index}"                #
#   rg_nam   = var.Project.resource_group.rg1[0]   #
#   locatio  = var.Project.resource_group.Location #
# }                                                #


# output "available_Public_Ips" {
#   depends_on = [module.public_ip]
#   value = [
#     for m in module.public_ip : m.Public_Ips_to_use
#   ]
# }

# #============================================================================================
# # =============     Mapping Subnet Names to Public IP Addresses    ================
# #============================================================================================
# locals {
#   # 1. Create a list of the map keys in a predictable, sorted order. 
#   #    This ensures the key order matches the implicit order of 'count' in module.public_ip.
#   required_subnet_names_sorted = sort(keys(local.pip_requirement))

#   # 2. Extract the list of IPs from the public_ip module output. 
#   #    This value is a list of IPs corresponding to the count index (0, 1, 2...).
#   available_ip_list = [
#     for m in module.public_ip : m.Public_Ips_to_use
#   ]

#   # 3. The transformation: Create a new map with the new IP values
#   subnet_to_public_ip_map = {
#     # Iterate over the sorted list of keys
#     for index, subnet_name in local.required_subnet_names_sorted :
#     # Key: The original subnet name (e.g., "frontend")
#     subnet_name =>
#     # Value: The IP address pulled from the list using the current index
#     element(local.available_ip_list, index)
#   }
# }

# output "subnet_ip_mapping" {
#   value       = local.subnet_to_public_ip_map
#   description = "A map correlating the required subnet names (keys) with the newly allocated Public IP addresses (values)."
# }

# #============================================================================================
# # =============     For Azurerm Public Ip for specific requirement landing zone.=============
# #============================================================================================

# # module "Network_interface" {
# #   depends_on = [module.public_ip]
# #   source     = "../../module/azurerm_network_interface"
# #   for_each   = {
# #     for key, id in module.Virtual_network.subnet_ids : key => id
# #     if contains(["frontend", "Backend"], key)
# #   }
# #   name_nic   = each.key
# #   rg_nam     = var.Project.resource_group.rg1[0]
# #   locatio    = var.Project.resource_group.Location
# #   subne_id   = each.value
# # }

# #============================================================================================
# #============================================================================================

# module "Network_interface" {
#   depends_on = [module.public_ip]
#   source     = "../../module/azurerm_network_interface"

#   # Filtered 'for_each' to only create NICs for 'frontend' and 'Backend' subnets
#   for_each = {
#     for key, id in module.Virtual_network.subnet_ids : key => id
#     if contains(["frontend", "Backend"], key)
#   }

#   name_nic = each.key
#   rg_nam   = var.Project.resource_group.rg1[0]
#   locatio  = var.Project.resource_group.Location
#   subne_id = each.value

#   # =========================================================================
#   # CORE LOGIC: Conditional Public IP Assignment
#   # =========================================================================
#   # If each.key (e.g., "frontend") is found in the map, it assigns the Public IP ID.
#   # If the key is NOT found, it returns 'null', which makes the argument optional.
#   public_ip_resource_id        = lookup(local.subnet_to_public_ip_map, each.key, null)
#   private_ip_allocation_method = "Dynamic"
# }

# #============================================================================================
# #============================================================================================
