#============== KINDLY RUN BELLOW COMMAND========== 
# $env:ARM_SUBSCRIPTION_ID = (az account show --query id -o tsv)


terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"

    }
  }
  backend "azurerm" {
    resource_group_name  = "DoNotDeleteRg"
    storage_account_name = "donotdeletestorage5"
    container_name       = "tfstate"
    key                  = "4_each_ter.tfstate"
  }
}

provider "azurerm" {
  features {
    virtual_machine {
      detach_implicit_data_disk_on_deletion = false
      delete_os_disk_on_deletion            = true
      # graceful_shutdown                     = false
      # skip_shutdown_and_force_delete        = false
    }

    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  # use_cli = true
  # subscription_id = "9ea53555-e829-4a44-979e-046e7d148cb5"
  # tenant_id       = "cb484d07-1268-4e17-b8eb-7a555e150ba9"
}


data "azurerm_client_config" "current" {}

output "Output_subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}


# $env:ARM_SUBSCRIPTION_ID = (az account show --query id -o tsv)