resource "azurerm_postgresql_flexible_server" "this" {
  resource_group_name               = var.resource_group_name
  name                              = var.postgresql_flexible_server_name != "" ? var.postgresql_flexible_server_name : "${var.name_prefix}-${var.location}"
  location                          = var.location
  sku_name                          = join("_", [lookup(local.tier_map, var.tier, "GeneralPurpose"), "Standard", var.size])
  storage_mb                        = var.storage_mb
  version                           = var.postgresql_version
  administrator_login               = var.administrator_login
  administrator_password            = var.administrator_password
  private_dns_zone_id               = azurerm_private_dns_zone.this.id
  delegated_subnet_id               = var.delegated_subnet_id
  backup_retention_days             = var.backup_retention_days
  geo_redundant_backup_enabled      = var.geo_redundant_backup_enabled
  zone                              = var.zone
  create_mode                       = var.create_mode
  point_in_time_restore_time_in_utc = var.create_mode == "PointInTimeRestore" ? var.point_in_time_restore_time_in_utc : null
  source_server_id                  = contains(["PointInTimeRestore ", "Replica"], var.source_server_id) ? var.source_server_id : null
  dynamic "identity" {
    for_each = var.identity != null ? toset([var.identity]) : toset([])
    content {
      type         = identity.value.type
      identity_ids = identity.value.type == "SystemAssigned" ? [] : identity.value.identity_ids
    }
  }

  dynamic "customer_managed_key" {
    for_each = var.identity != null && var.enable_customer_managed_key == true ? [1] : []
    content {
      key_vault_key_id                  = var.key_vault_key_id
      primary_user_assigned_identity_id = var.identity.type == "SystemAssigned" ? null : var.identity.identity_ids[0]
    }
  }

  dynamic "authentication" {
    for_each = var.authentication != {} ? ["authentication"] : []
    content {
      active_directory_auth_enabled = var.authentication.active_directory_auth_enabled
      password_auth_enabled         = var.authentication.password_auth_enabled
      tenant_id                     = var.authentication.active_directory_auth_enabled == true ? var.tenant_id : null
    }
  }

  dynamic "high_availability" {
    for_each = var.enable_high_availability && var.tier != "Burstable" ? toset(["enable_high_availability"]) : toset([])
    content {
      mode                      = "ZoneRedundant"
      standby_availability_zone = try(var.standby_zone, null)
    }
  }

  dynamic "maintenance_window" {
    for_each = var.maintenance_window != null ? toset([var.maintenance_window]) : toset([])

    content {
      day_of_week  = lookup(maintenance_window.value, "day_of_week", 0)
      start_hour   = lookup(maintenance_window.value, "start_hour", 0)
      start_minute = lookup(maintenance_window.value, "start_minute", 0)
    }
  }

  tags = var.tags

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.this
  ]
  lifecycle {
    ignore_changes = [
      zone,
      high_availability[0].standby_availability_zone
    ]
  }
}
