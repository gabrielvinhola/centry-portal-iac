resource "azurerm_private_dns_zone" "this" {
  name                = var.dnszone_name_prefix != "" ? "${var.dnszone_name_prefix}.postgres.database.azure.com" : "${var.name_prefix}-pdz.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "${var.name_prefix}-pdzvnetlink${var.vnet_link_name_suffix}"
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = var.virtual_network_id
  resource_group_name   = var.resource_group_name
  tags                  = var.tags
}
