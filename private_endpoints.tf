resource "azurerm_private_dns_zone" "dns_zone" {
  for_each            = var.private_dns
  name                = each.value.name
  resource_group_name = module.resourcegroups[each.value.rg_key].rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each              = var.private_dns
  name                  = "${each.key}-link"
  resource_group_name   = module.resourcegroups[each.value.rg_key].rg_name
  private_dns_zone_name = each.value.name
  virtual_network_id    = module.network["vnet-uks"].vnet_id
}

module "private_endpoints" {
  source   = "./modules/private_endpoint"
  for_each = var.private_endpoint

  private_endpoint_name = each.value.name
  resource_group_name   = module.resourcegroups[each.value.rg_key].rg_name
  location              = module.resourcegroups[each.value.rg_key].rg_location
  subnet_id             = lookup(module.network[each.value.vnet_key].subnet_id_list, each.value.snet_key)

  private_service_connection = {
    private_connection_resource_id    = lookup(local.resource_ids, each.value.resource, null)
    is_manual_connection              = each.value.is_manual_connection
    subresource_names                 = each.value.subresource_names
    private_connection_resource_alias = null
    request_message                   = null
  }
  private_dns_zone_ids = [azurerm_private_dns_zone.dns_zone[each.value.dns_key].id]
  tags                 = local.tags
}
