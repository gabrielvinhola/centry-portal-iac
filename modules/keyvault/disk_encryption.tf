resource "azurerm_disk_encryption_set" "this" {
  for_each                  = var.disk_encryption_sets
  name                      = each.value.encryption_set_name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  key_vault_key_id          = azurerm_key_vault_key.this[each.value.key_index].id
  encryption_type           = each.value.encryption_type
  auto_key_rotation_enabled = each.value.auto_key_rotation_enabled
  tags                      = var.tags
  lifecycle {
    ignore_changes = [tags]
  }
  identity {
    type = each.value.identity_type
  }
}
