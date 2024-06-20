resource "azurerm_key_vault_secret" "vault_secret" {
  for_each        = var.secrets
  name            = each.value.secret_name
  value           = each.value.secret_value
  key_vault_id    = azurerm_key_vault.this.id
  content_type    = each.value.content_type
  not_before_date = each.value.not_before_date
  expiration_date = each.value.expiration_date
  tags            = var.tags
}
