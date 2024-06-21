variable "resource_group_name" {
  type        = any
  description = "(Required) The resource group where the resource is created. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) The Azure Region where the Service Plan should exist. Changing this forces a new AppService to be created."
}

variable "name" {
  type        = string
  description = "(Required) The name which should be used for this Service Plan. Changing this forces a new AppService to be created."
}

variable "os_type" {
  type        = string
  description = "(Required) The O/S type for the App Services to be hosted in this plan. Possible values include Windows, Linux, and WindowsContainer. Changing this forces a new resource to be created."

  validation {
    condition     = contains(["Linux", "Windows", "WindowsContainer"], var.os_type)
    error_message = "Allowed values for input_parameter are \"Linux\", \"Windows\", or \"WindowsContainer\"."
  }
}

variable "sku_name" {
  type        = string
  description = "(Required) The SKU for the plan. Possible values include B1, B2, B3, D1, F1, I1, I2, I3, I1v2, I2v2, I3v2, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3, S1, S2, S3, SHARED, EP1, EP2, EP3, WS1, WS2, WS3, and Y1."
}

variable "tags" {
  type        = map(any)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

variable "zone_balancing_enabled" {
  type        = bool
  description = "(Optional) Should the Service Plan balance across Availability Zones in the region. Changing this forces a new resource to be created."
  default     = false
}

variable "worker_count" {
  type        = number
  description = "(Optional) The number of Workers (instances) to be allocated."
  default     = 1
}
