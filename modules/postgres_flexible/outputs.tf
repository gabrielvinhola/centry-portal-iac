output "postgresql_flexible_server_id" {
  description = "PostgreSQL server ID."
  value       = azurerm_postgresql_flexible_server.this.id
}

output "postgresql_flexible_fqdn" {
  description = "FQDN of the PostgreSQL server."
  value       = azurerm_postgresql_flexible_server.this.fqdn
}

output "public_network_access_enabled" {
  description = "Is public network access enabled?"
  value       = azurerm_postgresql_flexible_server.this.public_network_access_enabled
}

output "postgresql_flexible_database_ids" {
  description = "The ID of the Azure PostgreSQL Flexible Server Database."
  value       = tomap({ for k, v in azurerm_postgresql_flexible_server_database.this : k => v.id })
}

output "postgresql_flexible_server_name" {
  value       = azurerm_postgresql_flexible_server.this.name
  description = "postgresql flexible server name."
}

output "postgresql_administrator_login" {
  value       = azurerm_postgresql_flexible_server.this.administrator_login
  description = "postgresql admin user name."
}

output "postgresql_privatedns_name" {
  value       = azurerm_private_dns_zone.this.name
  description = "name of the private dns zone associated with the postgresql flexible server."
}