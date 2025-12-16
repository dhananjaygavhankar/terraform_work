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
    storage_account_name = "donotdeletestorage55"
    container_name       = "tfstate"
    key                  = "4_each_3ter.tfstate"
  }
}



provider "azurerm" {
  features {}
  # use_cli = true
  # subscription_id = "9ea53555-e829-4a44-979e-046e7d148cb5"
  # tenant_id       = "cb484d07-1268-4e17-b8eb-7a555e150ba9"
}


data "azurerm_client_config" "current" {}

output "Output_subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}


# $env:ARM_SUBSCRIPTION_ID = (az account show --query id -o tsv)