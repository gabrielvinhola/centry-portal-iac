resource "azurerm_storage_account" "this" {
  name                      = var.storage_account_name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_kind              = var.account_kind
  account_tier              = var.account_kind == "BlockBlobStorage" || var.account_kind == "FileStorage" ? "Premium" : var.account_tier
  account_replication_type  = var.account_replication_type
  enable_https_traffic_only = true
  min_tls_version           = var.min_tls_version
  access_tier               = var.access_tier
  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.type == "SystemAssigned" ? [] : identity.value.identity_ids
    }
  }
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  shared_access_key_enabled       = var.shared_access_key_enabled
  public_network_access_enabled   = var.public_network_access_enabled
  default_to_oauth_authentication = var.default_to_oauth_authentication
  is_hns_enabled                  = var.is_hns_enabled == true && var.account_tier == "Premium" ? (var.account_kind == "BlockBlobStorage" ? true : false) : var.is_hns_enabled
  sftp_enabled                    = var.is_hns_enabled == true ? var.sftp_enabled : false
  blob_properties {
    dynamic "cors_rule" {
      for_each = var.cors_rule != null ? ["cors_rules"] : []
      content {
        allowed_headers    = var.cors_rule.allowed_headers
        allowed_methods    = var.cors_rule.allowed_methods
        allowed_origins    = var.cors_rule.allowed_origins
        exposed_headers    = var.cors_rule.exposed_headers
        max_age_in_seconds = var.cors_rule.max_age_in_seconds
      }
    }
    delete_retention_policy {
      days = var.blob_soft_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.container_delete_retention_days
    }
    versioning_enabled       = var.enable_versioning
    last_access_time_enabled = var.last_access_time_enabled
    change_feed_enabled      = var.change_feed_enabled
    dynamic "restore_policy" {
      for_each = var.enable_versioning == true && var.change_feed_enabled == true ? ["restore_policy"] : []
      content {
        days = var.blob_restore_days
      }
    }
  }

  dynamic "customer_managed_key" {
    for_each = var.enable_customer_managed_key == true && var.customer_managed_key != null ? ["customer_managed_key"] : []
    content {
      key_vault_key_id          = var.customer_managed_key.key_vault_key_id
      user_assigned_identity_id = var.customer_managed_key.user_assigned_identity_id
    }
  }
  infrastructure_encryption_enabled = var.account_kind == "StorageV2" || (var.account_tier == "Premium" && contains(["BlockBlobStorage", "FileStorage"], var.account_kind)) ? var.infrastructure_encryption_enabled : false
  tags                              = var.tags

  dynamic "queue_properties" {
    for_each = var.account_kind != "BlobStorage" && var.queue_properties != null ? [var.queue_properties] : []
    content {
      logging {
        delete                = queue_properties.value.logging_read
        read                  = queue_properties.value.logging_delete
        write                 = queue_properties.value.logging_write
        version               = queue_properties.value.logging_version
        retention_policy_days = queue_properties.value.logging_retention_policy_days
      }
      hour_metrics {
        enabled               = queue_properties.value.hour_metrics_enabled
        include_apis          = queue_properties.value.hour_metrics_include_apis
        version               = queue_properties.value.hour_metrics_version
        retention_policy_days = queue_properties.value.hour_metrics_retention_policy_days
      }
      minute_metrics {
        enabled               = queue_properties.value.minute_metrics_enabled
        include_apis          = queue_properties.value.minute_metrics_include_apis
        version               = queue_properties.value.minute_metrics_version
        retention_policy_days = queue_properties.value.minute_metrics_retention_policy_days
      }
    }

  }

}

resource "azurerm_storage_account_network_rules" "this" {
  storage_account_id         = azurerm_storage_account.this.id
  default_action             = var.network_rules_default_action
  ip_rules                   = lookup(var.network_rules, "ip_rules", [])
  virtual_network_subnet_ids = lookup(var.network_rules, "virtual_network_subnet_ids", [])
  bypass                     = lookup(var.network_rules, "bypass", [])
  dynamic "private_link_access" {
    for_each = var.private_link_access_list
    content {
      endpoint_resource_id = private_link_access.value.endpoint_resource_id
      endpoint_tenant_id   = lookup(private_link_access.value, "endpoint_tenant_id", null)
    }
  }
}

resource "azurerm_storage_container" "this" {
  for_each              = { for container in var.containers_list : container.name => container }
  name                  = each.key
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = each.value.access_type
  depends_on = [
    azurerm_storage_account_network_rules.this
  ]
}

resource "azurerm_storage_share" "this" {
  for_each             = { for fs in var.file_shares : fs.name => fs }
  name                 = each.key
  storage_account_name = azurerm_storage_account.this.name
  quota                = each.value.quota
  depends_on = [
    azurerm_storage_account_network_rules.this
  ]
}

resource "azurerm_storage_table" "this" {
  count                = length(var.tables)
  name                 = var.tables[count.index]
  storage_account_name = azurerm_storage_account.this.name
  depends_on = [
    azurerm_storage_account_network_rules.this
  ]
}

resource "azurerm_storage_queue" "this" {
  count                = length(var.queues)
  name                 = var.queues[count.index]
  storage_account_name = azurerm_storage_account.this.name
  depends_on = [
    azurerm_storage_account_network_rules.this
  ]
}

resource "azurerm_advanced_threat_protection" "this" {
  target_resource_id = azurerm_storage_account.this.id
  enabled            = var.enable_advanced_threat_protection
}

resource "azurerm_storage_management_policy" "this" {
  count              = length(var.lifecycles) == 0 ? 0 : 1
  storage_account_id = azurerm_storage_account.this.id
  depends_on         = [azurerm_storage_account_network_rules.this]
  dynamic "rule" {
    for_each = var.lifecycles
    iterator = rule
    content {
      name    = "rule${rule.key}"
      enabled = true
      filters {
        prefix_match = rule.value.prefix_match
        blob_types   = [rule.value.blob_types]
        dynamic "match_blob_index_tag" {
          for_each = rule.value.match_blob_index_tag != null ? ["match_blob_index_tag"] : []
          content {
            name      = rule.value.match_blob_index_tag.name
            operation = rule.value.match_blob_index_tag.operation
            value     = rule.value.match_blob_index_tag.value
          }
        }
      }
      actions {
        base_blob {
          tier_to_cool_after_days_since_modification_greater_than    = rule.value.tier_to_cool_after_days
          tier_to_archive_after_days_since_modification_greater_than = rule.value.tier_to_archive_after_days
          delete_after_days_since_modification_greater_than          = rule.value.delete_after_days
        }
        snapshot {
          delete_after_days_since_creation_greater_than    = rule.value.snapshot_delete_after_days
          change_tier_to_archive_after_days_since_creation = rule.value.snapshot_tier_to_archive_after_days
          change_tier_to_cool_after_days_since_creation    = rule.value.snapshot_tier_to_cool_after_days
        }
        version {
          change_tier_to_archive_after_days_since_creation = rule.value.version_tier_to_archive_after_days
          change_tier_to_cool_after_days_since_creation    = rule.value.version_tier_to_cool_after_days
          delete_after_days_since_creation                 = rule.value.version_delete_after_days
        }
      }
    }
  }
}
