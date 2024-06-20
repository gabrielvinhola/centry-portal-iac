environment  = "dev"
landing_zone = "app"
location     = "uksouth"

#region Resource Groups
resource_groups = {
  default-uks = {
    prefix   = "rg"
    location = "uks"
  }
  network-uks = {
    prefix   = "rg-network"
    location = "uks"
  }
}

#region Virtual Networks
vnet_profile = {
  vnet-eus = {
    name             = "vnet-app-dev-uks-001"
    address_space    = ["10.68.26.0/24"]
    route_table_name = "udr-app-dev-uks-001"
    rg_key           = "network-uks"
    routes           = {}
    subnets = {
      frontend = {
        name                                          = "snet-frontend-app-dev-uks-001"
        private_link_service_network_policies_enabled = false
        private_endpoint_network_policies_enabled     = false
        address_prefixes                              = ["10.68.26.0/27"]
        delegation = {
          name = "delegation"
          service_delegation = {
            name = "Microsoft.Web/serverFarms"
          }
        }
        nsg_name  = "nsg-frontend-app-dev-uks-001"
        nsg_rules = []
      },
      backend = {
        name                                          = "snet-backend-app-dev-uks-001"
        private_link_service_network_policies_enabled = false
        private_endpoint_network_policies_enabled     = false
        address_prefixes                              = ["10.68.26.96/28"]
        delegation = {
          name = "delegation"
          service_delegation = {
            name = "Microsoft.Web/serverFarms"
          }
        }
        nsg_name  = "nsg-backend-app-dev-uks-001"
        nsg_rules = []
      },
      pe = {
        name                                          = "snet-pe-dev-uks-001"
        private_link_service_network_policies_enabled = true
        private_endpoint_network_policies_enabled     = true
        address_prefixes                              = ["10.68.26.176/29"]
        nsg_name                                      = "nsg-pe-app-dev-uks-001"
        nsg_rules                                     = []
      },
    }
  }
}
