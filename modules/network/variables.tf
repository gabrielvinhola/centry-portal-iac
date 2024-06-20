# network variables declaration
variable "resource_group_name" {
  type        = string
  description = "(Required) The resource group where the resource is created. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) The location/region where the virtual network is created. Changing this forces a new resource to be created."
}

variable "dns_servers" {
  type        = list(string)
  description = " (Optional) List of IP addresses of DNS servers"
  default     = []
}

variable "tags" {
  type        = map(any)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

variable "subnets" {
  type        = any
  description = <<EOD
    For each subnet, create an map object that contain fields name, address_prefixes, service_endpoints, service_endpoint_policy_ids, private_endpoint_network_policies_enabled,
    private_link_service_network_policies_enabled, delegation object.
    If there is a need of associating the subnet with different UDR other than default,
    then declare the varibale "route_table_name" in the subnet object with the value from the additional_route_tables variables.If route_table_name
    is not defined in the subnet then it will be associated to defualt Udr (defined in the variable route_table_name).

    ## 
    If we do not want to associate any UDR, set associate_udr value to false. Otherwise don't do anything
  EOD
  default     = {}
}

variable "routes" {
  type        = any
  description = "List of objects representing routes. Each object accepts the arguments documented below."
  default     = {}
}

variable "route_table_name" {
  type        = string
  description = "(Required) The name of the route table. Changing this forces a new resource to be created."
}

variable "additional_route_tables" {
  type = map(object({
    route_table_name              = string
    disable_bgp_route_propagation = optional(bool, true)
    routes = optional(list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    })), [])
  }))
  default     = {}
  description = "This variable is for creating additional route other than the default route which is declared in the variable 'route_table_name'."
}

variable "name" {
  type        = string
  description = "(Required) The name of the virtual network. Changing this forces a new resource to be created."
}

variable "address_space" {
  type        = list(string)
  description = "(Required) The address space that is used the virtual network. You can supply more than one address space."
}
