resource "azurerm_postgresql_flexible_server_configuration" "this" {
  for_each  = var.postgresql_configurations
  name      = each.key
  server_id = azurerm_postgresql_flexible_server.this.id
  value     = each.value
}
