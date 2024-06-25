terraform {
  required_version = "1.8.5"
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
      source  = "Azure/azapi"
      version = "~> 1.12.1"
    }
  }

  cloud {}
}

provider "random" {}


provider "azurerm" {
  features {}
}

# provider "azapi" {
#   use_oidc = true
# }