variable "resource_group_name" {
  description = "Name of the application ressource group."
  type        = string
}

variable "postgresql_flexible_server_name" {
  description = "The name which should be used for this PostgreSQL Flexible Server."
  type        = string
  default     = ""
}

variable "name_prefix" {
  default     = "postgresqlfs"
  description = "Prefix of the resource name."
  type        = string
}

variable "dnszone_name_prefix" {
  type        = string
  description = "prefix name of the private dns zone for postgresql flexible."
  default     = ""
}

variable "location" {
  type        = string
  description = "The Azure Region where the PostgreSQL Flexible Server should exist."
}

variable "tier" {
  description = "Tier for PostgreSQL Flexible server sku : https://docs.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-compute-storage. Possible values are: GeneralPurpose, Burstable, MemoryOptimized."
  type        = string
  default     = "GeneralPurpose"
  validation {
    condition     = contains(["GeneralPurpose", "Burstable", "MemoryOptimized"], var.tier)
    error_message = "Argument 'tier' must one of 'GeneralPurpose', 'Burstable', or 'MemoryOptimized'."
  }
}

variable "size" {
  description = "Size for PostgreSQL Flexible server sku : https://docs.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-compute-storage."
  type        = string
  default     = "D2ds_v4"
}

variable "storage_mb" {
  description = <<EOD
  The max storage allowed for the PostgreSQL Flexible Server.
  Possible values are 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, and 16777216.
  EOD
  type        = number
  default     = 32768
}

variable "postgresql_version" {
  description = <<EOD
  The version of PostgreSQL Flexible Server to use. Possible values are 11,12, 13 and 14.
  Required when create_mode is Default
  EOD
  type        = number
  default     = 13
}

variable "administrator_login" {
  description = "PostgreSQL administrator login."
  type        = string
}

variable "administrator_password" {
  description = "PostgreSQL administrator password. Strong Password : https://docs.microsoft.com/en-us/sql/relational-databases/security/strong-passwords?view=sql-server-2017."
  type        = string
}

variable "virtual_network_id" {
  description = <<EOD
  The ID of the Virtual Network that should be linked to the DNS Zone.
  This is required when delegated_subnet_id is set and private dns zone is created and
  ths is not required when using the existing postgresql private dns zone.
   EOD
  type        = string
  default     = ""
}

variable "delegated_subnet_id" {
  description = <<EOD
  The ID of the virtual network subnet to create the PostgreSQL Flexible Server.
  The provided subnet should not have any other resource deployed in it and this
  subnet will be delegated to the PostgreSQL Flexible Server.
  EOD
  type        = string
  default     = null
}

variable "backup_retention_days" {
  description = "Backup retention days for the PostgreSQL Flexible Server (Between 7 and 35 days)."
  type        = number
  default     = 30
}

variable "geo_redundant_backup_enabled" {
  description = "Enable Geo Redundant Backup for the PostgreSQL Flexible Server."
  type        = bool
  default     = false
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = "enable ManagedIndentity or system assigned identity."
  default     = null
}

variable "enable_customer_managed_key" {
  type        = bool
  description = "enable customer managed key."
  default     = false
}

variable "key_vault_key_id" {
  type        = string
  description = "keyvault key id is required when enable_customer_managed_key is set to true."
  default     = null
}

variable "zone" {
  description = "Specify availability-zone for PostgreSQL Flexible main Server."
  type        = number
  default     = 1
}

variable "standby_zone" {
  description = "Specify availability-zone to enable high_availability and create standby PostgreSQL Flexible Server. (Null to disable high-availability)"
  type        = number
  default     = null
}

variable "maintenance_window" {
  description = "Map of maintenance window configuration."
  type        = map(number)
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "authentication" {
  type = object({
    active_directory_auth_enabled = optional(bool)
    password_auth_enabled         = optional(bool, true)
  })
  description = "configure Active Directory authentication  to access the PostgreSQL Flexible Server."
  default     = {}
}

variable "postgresql_flexible_databases" {
  description = <<EOD
  Map of databases configurations with database name as key and following available configuration option:
   *  (optional) charset: Valid PostgreSQL charset : https://www.postgresql.org/docs/current/multibyte.html#CHARSET-TABLE
   *  (optional) collation: Valid PostgreSQL collation : https://www.postgresql.org/docs/current/collation.html
  EOD
  type = map(object({
    charset   = optional(string, "UTF8")
    collation = optional(string, "en_US.UTF8")
  }))
  default = {}
}

variable "postgresql_configurations" {
  description = <<EOD
  Map of postgresql_configurations with configuration name as key and value will be the PostgreSQL Configuration values.
   *Specifies the name of the PostgreSQL Configuration, which needs to be a valid PostgreSQL configuration name: https://www.postgresql.org/docs/current/sql-syntax-lexical.html#SQL-SYNTAX-IDENTIFIER
   *PostgreSQL provides the ability to extend the functionality using azure extensions,
    with PostgreSQL azure extensions you should specify the name value as azure.
    extensions and the value you wish to allow in the extensions list.
  EOD
  type        = map(string)
  default     = {}
}

variable "firewall_rules" {
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  description = "set of firewall rules. If using Cidr give the same cidr at both place start_ip_address & end_ip_address."
  default     = []
}

variable "enable_active_directory_administrator" {
  type        = bool
  description = "enable active directory administrator."
  default     = false
}

variable "active_directory_administrator" {
  type = list(object({
    object_id      = string
    principal_name = string
    principal_type = string
  }))
  description = <<EOD
  The object ID of a user, service principal or security group in the Azure Active Directory tenant set as the Flexible Server Admin.
  The name of Azure Active Directory principal. Changing this forces a new resource to be created.
  The type of Azure Active Directory principal. Possible values are Group, ServicePrincipal and User
  EOD
  default     = []
}

variable "tenant_id" {
  type        = string
  description = <<EOD
  tenant id
  This is required when authentication active_directory_auth_enabled is set to true or enable_active_directory_administrator is set to true.
  EOD
  default     = null
}

variable "create_mode" {
  type        = string
  description = "(Optional) The creation mode which can be used to restore or replicate existing servers. Possible values are Default, PointInTimeRestore, Replica and Update. Changing this forces a new PostgreSQL Flexible Server to be created."
  default     = "Default"
}

variable "point_in_time_restore_time_in_utc" {
  type        = string
  description = "(Optional) The point in time to restore from source_server_id when create_mode is PointInTimeRestore. Changing this forces a new PostgreSQL Flexible Server to be created."
  default     = null
}

variable "source_server_id" {
  type        = string
  description = "(Optional) The resource ID of the source PostgreSQL Flexible Server to be restored. Required when create_mode is PointInTimeRestore or Replica. Changing this forces a new PostgreSQL Flexible Server to be created."
  default     = "Default"
}

variable "vnet_link_name_suffix" {
  type        = string
  description = "Name suffix to append in the vnet link name for postgress private dns zone, ths is not required when using the existing postgresql private dns zone."
  default     = ""
}

variable "postgresql_privatednszone_id" {
  type        = string
  description = "(optional) Id of the existing postgresql private dns zone . This is required when the requirement is to use the existing postgresql private dns zone."
  default     = ""
}

variable "enable_high_availability" {
  type        = bool
  description = "enable high availability on postgresql flexi server."
  default     = false
}
