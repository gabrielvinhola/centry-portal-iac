output "connection_string" {
  value       = azurerm_application_insights.this.connection_string
  description = "The Connection String for this Application Insights component. (Sensitive)"
  sensitive   = true
}

output "instrumentation_key" {
  value       = azurerm_application_insights.this.instrumentation_key
  description = "The Instrumentation Key for this Application Insights component. (Sensitive)"
  sensitive   = true
}

output "app_insights_id" {
  value       = azurerm_application_insights.this.id
  description = "The ID of the Application Insights component."
}