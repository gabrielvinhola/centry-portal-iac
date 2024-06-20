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