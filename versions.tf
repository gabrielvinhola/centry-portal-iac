terraform {
  required_version = "~> 1.7.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.72.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.12.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
  }

  cloud {}
}

provider "random" {}


provider "azurerm" {
  features {}
}
