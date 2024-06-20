resource "azurerm_private_endpoint" "this" {
  name                          = var.private_endpoint_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  subnet_id                     = var.subnet_id
  custom_network_interface_name = var.custom_network_interface_name
  private_service_connection {
    name                              = "psc-${var.private_endpoint_name}"
    private_connection_resource_id    = lookup(var.private_service_connection, "private_connection_resource_id", null)
    is_manual_connection              = lookup(var.private_service_connection, "is_manual_connection", false)
    private_connection_resource_alias = lookup(var.private_service_connection, "private_connection_resource_id", null) == null ? var.private_service_connection.private_connection_resource_alias : null
    subresource_names                 = var.is_private_link_service == true ? null : try(var.private_service_connection.subresource_names, null)
    request_message                   = lookup(var.private_service_connection, "is_manual_connection", false) ? lookup(var.private_service_connection, "request_message", null) : null
  }

  dynamic "private_dns_zone_group" {
    for_each = var.is_private_link_service ? [] : ["private_dns_zone_group"]
    content {
      name                 = "pdzg-${var.private_endpoint_name}"
      private_dns_zone_ids = try(var.private_dns_zone_ids, [])
    }
  }

  dynamic "ip_configuration" {
    for_each = var.ip_configuration != null ? [var.ip_configuration] : []
    content {
      name               = ip_configuration.value.name
      private_ip_address = ip_configuration.value.private_ip_address
      subresource_name   = ip_configuration.value.subresource_name
      member_name        = ip_configuration.value.member_name
    }
  }

  tags = var.tags

}
