terraform {
  backend "azurerm" {
    resource_group_name  = "rg-backend"
    storage_account_name = "strgaccbackend"
    container_name       = "strgcontainer"
    key                  = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.42.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "1ef3481e-bfe1-4160-aeeb-862132dc8f0e"

}