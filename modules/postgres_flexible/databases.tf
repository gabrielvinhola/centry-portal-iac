resource "azurerm_postgresql_flexible_server_database" "this" {
  for_each  = var.postgresql_flexible_databases
  name      = each.key
  server_id = azurerm_postgresql_flexible_server.this.id
  charset   = each.value.charset
  collation = each.value.collation
}
