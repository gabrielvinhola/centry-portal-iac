output "vnet_name" {
  value       = azurerm_virtual_network.this.name
  description = "The name of the virtual network"
}

output "vnet_id" {
  value       = azurerm_virtual_network.this.id
  description = "The ID of the virtual network"
}

output "subnet_name_list" {
  description = "Virutal Network Name"
  value       = tomap({ for index, subnet in azurerm_subnet.this : index => subnet.name })
}

output "subnet_id_list" {
  description = "Virutal Network Name"
  value       = tomap({ for index, subnet in azurerm_subnet.this : index => subnet.id })
}

output "subnet_address_prefixes_list" {
  value       = tomap({ for index, subnet in azurerm_subnet.this : index => subnet.address_prefixes })
  description = "The address prefixes of the created subnet"
}

output "route_table_id" {
  value       = azurerm_route_table.this.id
  description = "The id of the single route table mapped to all subents"
}
