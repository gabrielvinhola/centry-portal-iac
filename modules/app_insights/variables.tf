variable "location" {
  type        = string
  description = "(Required) The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created"
}

variable "application_type" {
  type    = string
  default = "web"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The resource group for the deployment. Changing this forces a new Resource Group to be created."
}

variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Application Insights component."
}

variable "workspace_id" {
  type        = string
  description = "(Optional) Specifies the id of a log analytics workspace resource. Changing this forces a new resource to be created."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) A mapping of tags to assign to the resource."
}
