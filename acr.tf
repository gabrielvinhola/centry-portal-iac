resource "azurerm_container_registry" "this" {
  name                          = var.acr_name
  location                      = module.resourcegroups["default-uks"].rg_location
  resource_group_name           = module.resourcegroups["default-uks"].rg_name
  sku                           = "Premium"
  public_network_access_enabled = false
  admin_enabled                 = false
  tags                          = local.tags
}

