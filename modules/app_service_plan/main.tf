resource "azurerm_service_plan" "this" {
  name                   = var.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  os_type                = var.os_type
  sku_name               = var.sku_name
  zone_balancing_enabled = var.zone_balancing_enabled
  tags                   = var.tags
  worker_count           = var.worker_count
}
