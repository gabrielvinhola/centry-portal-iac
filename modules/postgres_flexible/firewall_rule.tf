resource "azurerm_postgresql_flexible_server_firewall_rule" "this" {
  for_each         = { for fr in var.firewall_rules : fr.name => fr }
  name             = each.value.name
  server_id        = azurerm_postgresql_flexible_server.this.id
  start_ip_address = can(cidrhost(each.value.start_ip_address, 0)) ? cidrhost(each.value.start_ip_address, 0) : each.value.start_ip_address
  end_ip_address   = can(cidrhost(each.value.start_ip_address, 0)) ? cidrhost(each.value.start_ip_address, -1) : each.value.end_ip_address
}