terraform {
  required_version = "~> 1.7.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.72.0"
    }

  cloud {}
}

provider "azurerm" {
  features {}
}
