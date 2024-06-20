variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group for the deployment. Changing this forces a new Resource Group to be created."
}

variable "location" {
  type        = string
  description = "(Required) The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created"
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
}
