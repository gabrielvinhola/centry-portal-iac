variable "private_endpoint_name" {
  type        = string
  description = "(Required) Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created."

}

variable "resource_group_name" {
  type        = string
  description = "(Required) Specifies the Name of the Resource Group within which the Private Endpoint should exist. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) The supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "subnet_id" {
  type        = string
  description = "(Required) The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created."
}

variable "custom_network_interface_name" {
  type        = string
  description = "(Optional) The custom name of the network interface attached to the private endpoint. Changing this forces a new resource to be created."
  default     = null
}

variable "is_private_link_service" {
  type        = bool
  description = "Is private endpoint is creating for private link service"
  default     = false
}

variable "private_service_connection" {
  type = object({
    private_connection_resource_id    = optional(string)
    is_manual_connection              = optional(bool)
    private_connection_resource_alias = optional(string)
    subresource_names                 = optional(list(string))
    request_message                   = optional(string)
  })
  description = <<EOD
   private_service_connection has following available configuration options.
   * is_manual_connection: (Required) Does the Private Endpoint require Manual Approval from the remote resource owner? Changing this forces a new resource to be created.
   * private_connection_resource_id= (Optional) The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to. One of private_connection_resource_id or private_connection_resource_alias must be specified.
   * private_connection_resource_alias= (Optional) The Service Alias of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to. One of private_connection_resource_id or private_connection_resource_alias must be specified. Changing this forces a new resource to be created.
   * subresource_names= (Optional) A list of subresource names which the Private Endpoint is able to connect to.
   * request_message= (Optional) A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource. The request message can be a maximum of 140 characters in length. Only valid if is_manual_connection is set to true.
  EOD
}

variable "private_dns_zone_ids" {
  type        = list(string)
  description = "(Required) Specifies the list of Private DNS Zones to include within the private_dns_zone_group."
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "ip_configuration" {
  type = object({
    name               = string
    private_ip_address = string
    subresource_name   = optional(string)
    member_name        = optional(string)
  })
  description = <<EOD
    ip_configuration has following  configuration options.
    * name : (Required) Specifies the Name of the IP Configuration. Changing this forces a new resource to be created.
    * private_ip_address: (Required) Specifies the static IP address within the private endpoint's subnet to be used. Changing this forces a new resource to be created.
    * subresource_name: (Optional) Specifies the subresource this IP address applies to. Changing this forces a new resource to be created.
    * member_name: (Optional) Specifies the member name this IP address applies to. If it is not specified, it will use the value of subresource_name. Changing this forces a new resource to be created.
    EOD
  default     = null
}
