output "private_endpoint_id" {
  value       = azurerm_private_endpoint.this.id
  description = "The ID of the Private Endpoint."
}

output "network_interface" {
  value       = azurerm_private_endpoint.this.network_interface
  description = "using network_interface you can export name and id of the network_interface associated with the private endpoint."

}

output "custom_dns_configs" {
  value       = azurerm_private_endpoint.this.custom_dns_configs
  description = "using custom_dns_configs you can export fqdn and ip_address associated with the private endpoint."

}

output "private_dns_zone_configs" {
  value       = azurerm_private_endpoint.this.private_dns_zone_configs
  description = <<EOD
    using private_dns_zone_configs you can export
     name - The name of the Private DNS Zone that the config belongs to.
     id - The ID of the Private DNS Zone Config.
     private_dns_zone_id - A list of IP Addresses
     record_sets - A record_sets block as defined below.
    EOD
}

output "private_service_connection" {
  value       = azurerm_private_endpoint.this.private_service_connection
  description = <<EOD
  using private_service_connection you can export
  private_ip_address - (Computed) The private IP address associated with the private endpoint, note that you will have a private IP address assigned
  to the private endpoint even if the connection request was Rejected.

  example=module.<module name>.private_service_connection.0.private_ip_address
  EOD
}
