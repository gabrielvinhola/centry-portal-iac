/*
  It create additional route table apart from the default route table if additional_route_tables variables is defined.

*/

resource "azurerm_route_table" "additional_route_tables" {
  for_each                      = var.additional_route_tables
  name                          = each.value.route_table_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = each.value.disable_bgp_route_propagation

  dynamic "route" {
    for_each = each.value.routes
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }

  tags = var.tags
}
