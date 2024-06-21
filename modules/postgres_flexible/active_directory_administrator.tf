resource "azurerm_postgresql_flexible_server_active_directory_administrator" "this" {
  for_each            = var.enable_active_directory_administrator == true ? { for ad in var.active_directory_administrator : ad.principal_name => ad } : {}
  server_name         = azurerm_postgresql_flexible_server.this.name
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  object_id           = each.value.object_id
  principal_name      = each.value.principal_name
  principal_type      = each.value.principal_type
}
