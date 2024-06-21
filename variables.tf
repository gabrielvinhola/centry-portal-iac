variable "resource_groups" {
  type = map(object({
    prefix   = string
    location = string
  }))
  description = "(Required) The list of resource groups for the deployment. Changing this forces a new Resource Group to be created."
}

variable "location" {
  description = "Primary location of the resources"
  type        = string
}

variable "landing_zone" {
  type        = string
  description = "(Required) The Application Landing Zone the terraform is being used for in it's short form"
}

variable "environment" {
  type        = string
  description = "(Required) Deployment environment i.e sandbox/dev/uat/prod"
}

variable "vnet_profile" {
  type        = any
  description = "(Required) Complete details of virtual network."
}


variable "keyvaults" {
  type = map(object({
    name                            = string
    sku_name                        = string
    bypass                          = string
    default_action                  = string
    rg_key                          = string
    subnet_ids                      = list(string)
    ip_rules                        = optional(list(string))
    enabled_for_disk_encryption     = optional(bool)
    enabled_for_deployment          = optional(bool)
    enabled_for_template_deployment = optional(bool)

    key_list = optional(map(object({
      key_name        = optional(string)
      expiration_date = optional(string)
    })), {})

    disk_encryption_set = optional(map(object({
      encryption_set_name = optional(string)
      key_index           = optional(string)
    })), {})
  }))
  description = "Complete details of keyvaults."
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
}

variable "private_endpoint" {
  type = map(object({
    name                 = string
    rg_key               = string
    vnet_key             = string
    snet_key             = string
    dns_key              = string
    resource             = string
    is_manual_connection = bool
    subresource_names    = list(string)
    request_message      = string
  }))
  description = "Complete details of private_endpoint."
}

variable "private_dns" {
  type = map(object({
    name   = string
    rg_key = string
  }))
  description = "Complete details of private_dns."
}

variable "storage_profile" {
  type = object({
    name                              = string
    rg_key                            = string
    account_kind                      = string
    account_tier                      = string
    account_replication_type          = string
    min_tls_version                   = string
    shared_access_key_enabled         = bool
    blob_soft_delete_retention_days   = optional(number, 7)
    container_delete_retention_days   = optional(number, 7)
    blob_restore_days                 = optional(number)
    enable_versioning                 = optional(bool, false)
    change_feed_enabled               = optional(bool, false)
    infrastructure_encryption_enabled = optional(bool, false)
    containers_list                   = optional(list(object({ name = string, access_type = string })), [])
    vnet_key                          = optional(string, "vnet-uks")
  })
  description = "Specifies the details of the Storage Account."
}

variable "app_insights" {
  type = object({
    name   = string
    rg_key = string
  })
  description = "(Required) The details of app insights for the app services."
}

variable "app_service_plan" {
  type = object({
    name   = string
    rg_key = string
  })
  description = "(Required) The details of the app service plan for the deployment."
}

variable "worker_count" {
  type        = number
  description = "(Optional) The number of Workers (instances) to be allocated."
  default     = 1
}

variable "zone_balancing_enabled" {
  type        = bool
  description = "(Optional) Should the Service Plan balance across Availability Zones in the region. Changing this forces a new resource to be created."
  default     = false
}

variable "log_analytics_workspace" {
  type = object({
    name     = string
    location = string
    rg_key   = string
  })
  description = "Details of log analytics workspace"
}

variable "frontend" {
  type = object({
    name                          = string
    rg_key                        = string
    vnet_key                      = string
    snet_key                      = string
    env                           = string
    docker_image_tag              = optional(string, "latest")
    require_assignment            = optional(bool, false)
    allowed_origins               = optional(list(string))
    public_network_access_enabled = optional(bool, false)
  })
  description = "(Required) The details of filestore app service."
}

variable "backend" {
  type = object({
    name                          = string
    rg_key                        = string
    vnet_key                      = string
    snet_key                      = string
    env                           = string
    docker_image_tag              = optional(string, "latest")
    require_assignment            = optional(bool, false)
    allowed_origins               = optional(list(string))
    public_network_access_enabled = optional(bool, false)
  })
  description = "(Required) The details of filestore app service."
}
