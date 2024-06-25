// Outputs
output "app_service" {
  value = azurerm_linux_web_app.this
}

output "identity" {
  value       = azurerm_linux_web_app.this.identity.0.principal_id
  description = "Linux Web App Managed Identity Principal ID"
}

output "app_service_id" {
  value       = azurerm_linux_web_app.this.id
  description = "ID of the app service"
}