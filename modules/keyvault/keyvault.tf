
data "azurerm_client_config" "current" {
}

resource "azurerm_key_vault" "this" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = var.sku_name
  tags                            = var.tags
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization

  purge_protection_enabled   = var.purge_protection_enabled
  soft_delete_retention_days = var.soft_delete_retention_days

  public_network_access_enabled = var.public_network_access_enabled

  network_acls {
    bypass                     = var.bypass_traffic
    default_action             = var.default_action
    ip_rules                   = var.key_vault_ip_rules
    virtual_network_subnet_ids = var.subnet_ids
  }

  dynamic "access_policy" {
    for_each = var.access_policies
    content {
      tenant_id               = lookup(access_policy.value, "tenant_id", null)
      object_id               = lookup(access_policy.value, "object_id", null)
      key_permissions         = lookup(access_policy.value, "key_permissions", null)
      secret_permissions      = lookup(access_policy.value, "secret_permissions", null)
      certificate_permissions = lookup(access_policy.value, "certificate_permissions", null)
    }
  }
}
