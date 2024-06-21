variable "name" {
  description = "(Required) The name of the key-vault. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  type        = string
  description = "(Required) Name of the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the vault. Changing this forces a new resource to be created."
  type        = string
}

variable "sku_name" {
  description = "(Required) The Name of the SKU used for this Key Vault. Possible values are standard and premium."
  type        = string
}

variable "bypass_traffic" {
  type        = string
  description = "(Required) Specifies which traffic can bypass the network rules. Possible values are AzureServices and None"
}

variable "key_vault_ip_rules" {
  type        = list(string)
  description = "One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault"
  default     = []
}

variable "default_action" {
  type        = string
  description = "(Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny."
  default     = "Deny"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The list of subnet_ids that require access to this key_vault"
  default     = []
}

variable "access_policies" {
  description = "(Optional) A list of up to 1024 objects describing access policies"
  type = map(object({
    tenant_id               = string
    object_id               = string
    key_permissions         = list(string)
    secret_permissions      = list(string)
    certificate_permissions = list(string)
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags which should be assigned to the resource."
  type        = map(string)
  default     = {}
}

variable "purge_protection_enabled" {
  description = "(Optional) enable purge protection."
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "(Optional) The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days."
  type        = number
  default     = 90
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether public network access is allowed for this Key Vault."
  type        = bool
  default     = false
}

variable "enabled_for_deployment" {
  description = "(Optional) Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault."
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "(Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "(Optional) Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault."
  type        = bool
  default     = false
}

variable "enable_rbac_authorization" {
  description = "(Optional) Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions."
  type        = bool
  default     = false
}

variable "secrets" {
  type = map(object({
    secret_name     = string
    secret_value    = string
    content_type    = optional(string, null)
    not_before_date = optional(string, null)
    expiration_date = optional(string, null)
  }))
  description = "(Optional) List of objects that represent the configuration of each secret."
  default     = {}
}


variable "disk_encryption_sets" {
  type = map(object({
    encryption_set_name       = optional(string)
    encryption_type           = optional(string, "EncryptionAtRestWithPlatformAndCustomerKeys")
    auto_key_rotation_enabled = optional(bool, false)
    identity_type             = optional(string, "SystemAssigned")
    key_index                 = optional(string)
  }))
  description = "(Optional) List of objects that represent the configuration of each disk encryption sets."
  default     = {}
}

variable "keys_list" {
  type = map(object({
    key_name        = optional(string)
    key_type        = optional(string, "RSA")
    key_size        = optional(number, 2048)
    expiration_date = optional(string)
    key_opts        = optional(list(string), ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey", ])
  }))
  description = "(Optional) List of objects that represent the configuration of each keys."
  default     = {}
}
