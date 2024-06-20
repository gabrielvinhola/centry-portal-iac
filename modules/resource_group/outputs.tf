output "rg_name" {
  value       = azurerm_resource_group.rg.name
  description = "The name of the Resource Group."
}

output "rg_id" {
  value       = azurerm_resource_group.rg.id
  description = "The ID of the Resource Group."
}

output "rg_location" {
  value       = azurerm_resource_group.rg.location
  description = "The Location of the Resource Group."
}
