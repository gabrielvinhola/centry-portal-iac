module "cdn_frontdoor_dev" {
  source                 = "./modules/frontdoor"
  frontdoor_profile_name = "cdn-frontdoor-profile-dev-001"
  resource_group_name    = module.resourcegroups["default-uks"].rg_name
  sku_name               = "Premium_AzureFrontDoor"

  endpoints = [
    {
      custom_resource_name = "app-dev"
      name                 = "app-dev"
      enabled              = true
    },
  ]

  origin_groups = [
    {
      custom_resource_name = "app-dev"
      name                 = "app-dev"
    },
  ]

  origins = [
    {
      custom_resource_name           = "app-dev-uks-001"
      name                           = "app-dev-origin"
      origin_group_name              = "app-dev"
      certificate_name_check_enabled = true
      host_name                      = "front-app-dev-uks-001.azurewebsites.net"
      origin_host_header             = "front-app-dev-uks-001.azurewebsites.net"
      http_port                      = 80
      https_port                     = 443
      private_link = {
        request_message        = "for app dev"
        target_type            = "sites"
        location               = "uksouth"
        private_link_target_id = module.frontend.app_service_id
      }
    },
  ]

  routes = [
    {
      enabled              = true
      custom_resource_name = "app-dev-route"
      name                 = "app"
      endpoint_name        = "app-dev"
      origin_group_name    = "app-dev"
      origins_names        = ["app-dev-origin"]
      forwarding_protocol  = "MatchRequest"
      patterns_to_match    = ["/*"]
      supported_protocols  = ["Http", "Https"]
      rule_sets_names      = []
    },
  ]

  rule_sets = [
    {
      name                 = "my_rule_set"
      custom_resource_name = "AppRuleset001"
    }
  ]
  tags = {
    "Managed By" : "Terraform"
  }
}


# resource "azapi_update_resource" "dev_frontdoor_system_identity" {
#   type        = "Microsoft.Cdn/profiles@2023-02-01-preview"
#   resource_id = module.cdn_frontdoor_dev.profile_id
#   body = jsonencode({
#     "identity" : {
#       "type" : "SystemAssigned"
#     }
#   })
# }