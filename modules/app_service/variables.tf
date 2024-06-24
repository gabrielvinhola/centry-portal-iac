variable "rg_name" {
  type        = string
  description = "(Required) resource group name."
}

variable "name" {
  type        = string
  description = "(Required) app service name."
}

variable "asp_id" {
  type        = string
  description = "(Required) The resource id of the app service plan."
}

variable "location" {
  type        = string
  description = "(Required) The cafoud region where resources will be deployed into."
}

variable "https_only" {
  type        = bool
  description = "(Optional) Booolean to toggle if the App Service can only be accessed via HTTPS."
  default     = true
}

variable "http2_enabled" {
  type        = bool
  description = "Boolean to enable http version in appservice"
  default     = false
}

variable "client_affinity_enabled" {
  type        = bool
  description = "(Optional) Should the App Service send session affinity cookies, which route client requests in the same session to the same instance?"
  default     = false
}

variable "client_cert_enabled" {
  description = "(Optional) Does the App Service require client certificates for incoming requests? Defaults to false"
  type        = bool
  default     = false
}

variable "virtual_network_subnet_id" {
  type        = string
  default     = ""
  description = "(Optional) The app command line to launch."
}

variable "app_service_settings" {
  description = "(Optional) Variables passed as environment variables"
  type        = map(any)
  default     = {}
}

variable "docker_image" {
  type        = string
  default     = null
  description = "(Optional) If using User Managed Identity, the User Managed Identity client Id"
}

variable "docker_image_tag" {
  description = "Docker Image Tag"
  type        = string
  default     = "latest"
}

variable "log_analytics_workspace_id" {
  description = "(Optional) Login parameters to send to the OpenID Connect authorization endpoint when a user logs in. Each parameter must be in the form key=value."
  type        = string
}

variable "app_service_diagnostics" {
  description = "(Optional) Diagnostic settings for those resources that support it."
  type        = object({ logs = list(string), metrics = list(string) })
  default = {
    logs    = ["AppServiceAntivirusScanAuditLogs", "AppServiceHTTPLogs", "AppServiceConsoleLogs", "AppServiceAppLogs", "AppServiceFileAuditLogs", "AppServiceAuditLogs", "AppServiceIPSecAuditLogs", "AppServicePlatformLogs"]
    metrics = ["AllMetrics"]
  }
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
}

variable "identity_type" {
  type        = string
  description = "(Required) Specifies the type of Managed Service Identity that should be configured on this Linux Web App. Possible values are SystemAssigned, UserAssigned, and SystemAssigned, UserAssigned (to enable both)."
}

variable "identity_ids" {
  type        = list(string)
  description = "(Optional) A list of User Assigned Managed Identity IDs to be assigned to this Linux Web App."
  default     = []
}

variable "env" {
  type        = string
  description = "(Optional) Diagnostic rule name environment based. "
  default     = "tst"
}

variable "allowed_origins" {
  type        = list(string)
  description = "(Optional) Specifies a list of origins that should be allowed to make cross-origin calls."
  default     = ["*"]
}

variable "support_credentials" {
  type        = bool
  description = "(Optional) Whether CORS requests with credentials are allowed."
  default     = false
}


variable "settings" {
  description = "Specifies the Authentication enabled or not"
  default     = false
  type        = any
}

variable "site_config" {
  description = "Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is not managed in this block."
  type        = any
  default     = {}
}

variable "log_analytics_destination_type" {
  description = "(Optional) Possible values are AzureDiagnostics and Dedicated. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table."
  type        = string
  default     = "AzureDiagnostics"
}

variable "require_assignment" {
  type        = bool
  default     = false
  description = "Applicable for only filestore app service"
}

variable "failed_request_tracing" {
  type        = bool
  default     = true
  description = "(Optional) Should the failed request tracing be enabled."
}

variable "detailed_error_messages" {
  type        = bool
  default     = true
  description = "(Optional) Should detailed error messages be enabled."
}

variable "scope" {
  type        = string
  default     = ""
  description = "scope of the role assignment"
}

variable "role_assignments" {
  type = map(object({
    role = string
  }))
  default = {
    "assignment1" = {
      role = "Reader" # Specify the role for assignment 1
    }
    "assignment2" = {
      role = "Reader" # Specify the role for assignment 2
    }
    # Add more assignments as needed
  }
}


variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Is public network access enabled? If yes, please pass the resource group ID as well"
}

variable "rg_id" {
  type        = string
  default     = ""
  description = "ID of the resource group. Only required if public network access is enabled."
}

variable "custom_domain_enabled" {
  description = "(Optional) Should the App Service custom host name be enabled ? Defaults to false"
  type        = bool
  default     = false
}

variable "custom_domain_details" {
  type = object({
    key_vault_id          = optional(string)
    key_vault_secret_name = optional(string)
    cert_name             = optional(string)
    host_name             = optional(string)
  })
  description = "Details of the custom domain to be enabled on the App Service."
  default     = null
}

variable "auth_settings" {
  type = object({
    enabled                       = optional(bool)
    issuer                        = optional(string)
    token_refresh_extension_hours = optional(number)
    active_directory = optional(object({
      client_id                  = optional(string)
      client_secret              = optional(string)
      allowed_audiences          = optional(list(string))
      client_secret_setting_name = optional(string)

    }), null)
  })
  description = "auth_settings to be enabled on the App Service."
  default     = {}
}

variable "health_check_path" {
  type        = string
  description = "(Optional) The path to the Health Check."
  default     = null
}

variable "health_check_eviction_time_in_min" {
  type        = number
  description = "(Optional) The amount of time in minutes that a node can be unhealthy before being removed from the load balancer. Possible values are between 2 and 10. Only valid in conjunction with health_check_path"
  default     = null
}

variable "container_registry_use_managed_identity" {
  description = "Whether to use managed identity for acr connections"
  type        = bool
  default     = false
}
