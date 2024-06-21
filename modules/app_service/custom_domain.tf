//Enable custom domain - domain DNS record should exist already or else binding will fail 

// Bug  with Azurerm to use cert from a different subscription - https://github.com/hashicorp/terraform-provider-azurerm/issues/17181
# resource "azurerm_app_service_certificate" "this" {
#   count               = var.custom_domain_enabled && var.custom_domain_details != null ? 1 : 0
#   name                = var.custom_domain_details.cert_name
#   resource_group_name = var.rg_name
#   location            = var.location
#   key_vault_secret_id = var.custom_domain_details.key_vault_secret_id
# }

resource "azapi_resource" "this" {
  count     = var.custom_domain_enabled && var.custom_domain_details != null ? 1 : 0
  type      = "Microsoft.Web/certificates@2022-03-01"
  name      = var.custom_domain_details.cert_name
  parent_id = var.rg_id
  location  = var.location

  body = jsonencode({
    properties = {
      keyVaultId         = var.custom_domain_details.key_vault_id
      keyVaultSecretName = var.custom_domain_details.key_vault_secret_name
      serverFarmId       = var.asp_id
    }
    kind = "string"
  })
  response_export_values = ["properties.thumbprint"]

  lifecycle {
    replace_triggered_by = [
      azurerm_linux_web_app.this
    ]
  }

}

resource "azurerm_app_service_custom_hostname_binding" "this" {
  count               = var.custom_domain_enabled && var.custom_domain_details != null ? 1 : 0
  hostname            = var.custom_domain_details.host_name
  app_service_name    = var.name
  resource_group_name = var.rg_name
}


resource "azurerm_app_service_certificate_binding" "this" {
  count               = var.custom_domain_enabled && var.custom_domain_details != null ? 1 : 0
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.this[0].id
  certificate_id      = azapi_resource.this[0].id
  ssl_state           = "SniEnabled"
}
