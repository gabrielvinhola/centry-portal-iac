resource "azurerm_role_assignment" "assignments" {
  for_each = var.require_assignment ? var.role_assignments : {}

  scope                = var.scope
  role_definition_name = each.value.role
  principal_id         = azurerm_linux_web_app.this.identity.0.principal_id
}
