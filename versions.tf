terraform {
  required_version = "1.7.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    azapi = {
      source = "Azure/azapi"
    }
  }

  cloud {}
}

provider "random" {}


provider "azurerm" {
  features {}
}
