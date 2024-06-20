resource "azurerm_key_vault_key" "this" {
  for_each        = var.keys_list
  name            = each.value.key_name
  key_vault_id    = azurerm_key_vault.this.id
  key_type        = each.value.key_type
  key_size        = each.value.key_size
  expiration_date = each.value.expiration_date == "" ? time_offset.expiry_date.rfc3339 : each.value.expiration_date
  key_opts        = each.value.key_opts
  tags            = var.tags
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "time_offset" "expiry_date" {
  offset_months = 3
}
