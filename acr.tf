resource "azurerm_container_registry" "this" {
  name                          = var.acr_name
  location                      = module.resourcegroups["default-uks"].rg_location
  resource_group_name           = module.resourcegroups["default-uks"].rg_name
  sku                           = "Premium"
  public_network_access_enabled = false
  admin_enabled                 = false
  tags                          = local.tags
}

data "azuread_service_principal" "this" {
  display_name = ""
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.this.id
  role_definition_name = "AcrPush"
  principal_id         = data.azuread_service_principal.this.object_id
}
