terraform {

  required_version = "~>1.8.5"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.12.1"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
  }
}
