resource "azurerm_container_registry" "this" {
  name                          = var.acr_name
  location                      = module.resourcegroups["default-uks"].rg_location
  resource_group_name           = module.resourcegroups["default-uks"].rg_name
  sku                           = "Premium"
  public_network_access_enabled = false
  admin_enabled                 = false
  tags                          = local.tags
}

data "azurerm_client_config" "current" {
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.this.id
  role_definition_name = "AcrPush"
  principal_id         = data.azurerm_client_config.current.client_id
}
