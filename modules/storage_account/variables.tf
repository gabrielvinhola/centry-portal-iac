variable "storage_account_name" {
  type        = string
  description = "Specifies the name of the storage account."

}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the storage account."
}

variable "location" {
  type        = string
  description = "pecifies the supported Azure location where the resource exists."

}

variable "account_kind" {
  type        = string
  description = "Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2."
  validation {
    condition     = contains(["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"], var.account_kind)
    error_message = "Argument 'account_kind' must one of 'BlobStorage', 'BlockBlobStorage','FileStorage', 'Storage' or 'StorageV2'."
  }
  default = "StorageV2"
}

variable "account_tier" {
  type        = string
  description = <<EOD
    Defines the Tier to use for this storage account.
    Valid options are Standard and Premium.
    For BlockBlobStorage and FileStorage accounts only Premium is valid.
    EOD
}

variable "account_replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS."
}

variable "min_tls_version" {
  type        = string
  description = "The minimum supported TLS version for the storage account. Possible values are TLS1_0, TLS1_1, and TLS1_2. Defaults to TLS1_2 for new storage accounts."
  default     = "TLS1_2"
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = "enable ManagedIndentity or system assigned identity."
  default     = null
}

variable "shared_access_key_enabled" {
  type        = bool
  description = <<EOD
  ndicates whether the storage account permits requests to be authorized with the account access key via Shared Key.
  If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD).
  EOD
  default     = true
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Whether the public network access is enabled?"
}

variable "default_to_oauth_authentication" {
  type        = bool
  default     = false
  description = "Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account. The default value is false."
}

variable "is_hns_enabled" {
  type        = bool
  description = "Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2."
  default     = false
}

variable "blob_soft_delete_retention_days" {
  type        = number
  description = "Specifies the number of days that the blob should be retained, between 1 and 365 days."
  default     = 7
}

variable "blob_restore_days" {
  type        = number
  description = "Specifies the number of days that the blob can be restored, between 1 and 365 days. This must be less than the days specified for delete_retention_policy."
  default     = null
}

variable "cors_rule" {
  type = object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  })
  default     = null
  description = <<EOD
    *allowed_headers - (Required) A list of headers that are allowed to be a part of the cross-origin request.
    *allowed_methods - (Required) A list of HTTP methods that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH.
    *allowed_origins - (Required) A list of origin domains that will be allowed by CORS.
    *exposed_headers - (Required) A list of response headers that are exposed to CORS clients.
    *max_age_in_seconds - (Required) The number of seconds the client should cache a preflight response.
    EOD
}

variable "container_delete_retention_days" {
  type        = number
  default     = 7
  description = "Specifies the number of days that the container should be retained, between 1 and 365 days. Defaults to 7."
}

variable "enable_customer_managed_key" {
  type        = bool
  default     = false
  description = "enable customer managed key encryption on the storage account."
}

variable "customer_managed_key" {
  type = object({
    key_vault_key_id          = string
    user_assigned_identity_id = string
  })
  default     = null
  description = <<EOD
 * key_vault_key_id - (Required) The ID of the Key Vault Key, supplying a version-less key ID will enable auto-rotation of this key.
 * user_assigned_identity_id - (Required) The ID of a user assigned identity.
 *customer_managed_key can only be set when the account_kind is set to StorageV2 or account_tier set to Premium, and the identity type is UserAssigned.
 EOD
}

variable "sftp_enabled" {
  type        = bool
  description = "Boolean, enable SFTP for the storage account, SFTP support requires is_hns_enabled set to true. More information on SFTP support can be found here. Defaults to false."
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "network_rules" {
  description = <<EOD
  Network rules restricing access to the storage account.
  example network_rules={ "ip_rules" = [""], "virtual_network_subnet_ids" =[""], "bypass"=[""]}
  EOD
  type        = map(any)
  default     = {}

}

variable "enable_versioning" {
  description = "Is versioning enabled? Default to `false`"
  default     = false
  type        = bool
}

variable "last_access_time_enabled" {
  description = "Is the last access time based tracking enabled? Default to `false`"
  default     = false
  type        = bool
}

variable "change_feed_enabled" {
  description = "Is the blob service properties for change feed events enabled?"
  default     = false
  type        = bool
}

variable "private_link_access_list" {
  type = list(object({
    endpoint_resource_id = string
    endpoint_tenant_id   = optional(string)
  }))
  description = "One or More private_link_access block"
  default     = []
}

variable "enable_advanced_threat_protection" {
  description = "Boolean flag which controls if advanced threat protection is enabled."
  default     = false
  type        = bool
}

variable "containers_list" {
  description = "List of containers to create and their access levels."
  type        = list(object({ name = string, access_type = string }))
  default     = []
}

variable "file_shares" {
  description = "List of containers to create and their access levels."
  type        = list(object({ name = string, quota = number }))
  default     = []
}

variable "tables" {
  description = "List of storage tables."
  type        = list(string)
  default     = []
}

variable "queues" {
  description = "List of storages queues"
  type        = list(string)
  default     = []
}

variable "network_rules_default_action" {
  type        = string
  default     = "Deny"
  description = "Specifies the default action of allow or deny in network rules when no other rules match. Valid options are Deny or Allow."

}

variable "access_tier" {
  type        = string
  default     = "Hot"
  description = " Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
}

variable "lifecycles" {
  description = "Configure Azure Storage blob Management Policy."
  type = list(object({
    prefix_match = set(string)
    blob_types   = string
    match_blob_index_tag = optional(object({
      name      = string
      operation = string
      value     = string
    }), null)
    tier_to_cool_after_days             = number
    tier_to_archive_after_days          = number
    delete_after_days                   = number
    snapshot_delete_after_days          = optional(number, -1)
    snapshot_tier_to_cool_after_days    = optional(number, -1)
    snapshot_tier_to_archive_after_days = optional(number, -1)
    version_delete_after_days           = optional(number, -1)
    version_tier_to_cool_after_days     = optional(number, -1)
    version_tier_to_archive_after_days  = optional(number, -1)
  }))
  default = []
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  default     = false
  description = "(Optional) Allow or disallow nested items within this Account to opt into being public."
}

variable "queue_properties" {
  type = object({
    logging_read                         = bool
    logging_delete                       = bool
    logging_write                        = bool
    logging_version                      = string
    logging_retention_policy_days        = number
    hour_metrics_enabled                 = bool
    hour_metrics_include_apis            = bool
    hour_metrics_version                 = string
    hour_metrics_retention_policy_days   = number
    minute_metrics_enabled               = bool
    minute_metrics_include_apis          = bool
    minute_metrics_version               = string
    minute_metrics_retention_policy_days = number
  })
  default     = null
  description = "queue_properties cannot be set when the account_kind is set to BlobStorage"
}

variable "infrastructure_encryption_enabled" {
  type        = bool
  default     = false
  description = " (Optional) Is infrastructure encryption enabled? Changing this forces a new resource to be created. Defaults to false."
}