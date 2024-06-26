environment  = "dev"
landing_zone = "app"
location     = "uksouth"

#region Resource Groups
resource_groups = {
  default-uks = {
    prefix   = "rg"
    location = "uksouth"
  }
  network-uks = {
    prefix   = "rg-network"
    location = "uksouth"
  }
}

#region Virtual Networks
vnet_profile = {
  vnet-uks = {
    name             = "vnet-app-dev-uks-001"
    address_space    = ["10.68.26.0/24"]
    route_table_name = "udr-app-dev-uks-001"
    rg_key           = "network-uks"
    routes           = {}
    subnets = {
      app_service = {
        name                                          = "snet-appservice-app-dev-uks-001"
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
      pe = {
        name                                          = "snet-pe-dev-uks-001"
        private_link_service_network_policies_enabled = true
        private_endpoint_network_policies_enabled     = true
        address_prefixes                              = ["10.68.26.32/27"]
        nsg_name                                      = "nsg-pe-app-dev-uks-001"
        nsg_rules                                     = []
      },
      postgres = {
        name                                          = "snet-postgres-dev-uks-001"
        private_link_service_network_policies_enabled = true
        private_endpoint_network_policies_enabled     = true
        address_prefixes                              = ["10.68.26.64/27"]
        delegation = {
          name = "delegation"
          service_delegation = {
            name    = "Microsoft.DBforPostgreSQL/flexibleServers"
            actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
          }
        }
        nsg_name  = "nsg-pgresqlreftable-cyberpqui-dev-eastus2-001"
        nsg_rules = []
      }
    }
  }
}


keyvaults = {
  kv-app-dev = {
    name           = "kv-app-d-eu-001"
    sku_name       = "standard"
    bypass         = "AzureServices"
    default_action = "Deny"
    rg_key         = "default-uks"
    subnet_ids     = []
    subnet_ids     = []
    ip_rules       = []
  }
}

storage_profile = {
  name                              = "stappdevuksouth001"
  rg_key                            = "default-uks"
  account_kind                      = "StorageV2"
  account_tier                      = "Standard"
  account_replication_type          = "GRS"
  min_tls_version                   = "TLS1_2"
  shared_access_key_enabled         = true
  infrastructure_encryption_enabled = true
}

acr_name = "crappdevuksouth"

private_endpoint = {
  pe_uks_kv = {
    name                 = "pe-keyvault-app-dev-uks-001"
    rg_key               = "network-uks"
    vnet_key             = "vnet-uks"
    snet_key             = "pe"
    dns_key              = "kv_dns"
    resource             = "kv"
    is_manual_connection = false
    subresource_names    = ["vault"]
    request_message      = ""
  }
  pe_uks_storage = {
    name                 = "pe-storageaccount-app-dev-uks-001"
    rg_key               = "network-uks"
    vnet_key             = "vnet-uks"
    snet_key             = "pe"
    dns_key              = "storage_dns"
    resource             = "storage_accnt"
    is_manual_connection = false
    subresource_names    = ["Blob"]
    request_message      = ""
  }
  pe_uks_acr = {
    name                 = "pe-acr-app-dev-uks-001"
    rg_key               = "network-uks"
    vnet_key             = "vnet-uks"
    snet_key             = "pe"
    dns_key              = "acr_dns"
    resource             = "acr"
    is_manual_connection = false
    subresource_names    = ["registry"]
    request_message      = ""
  }
  pe_uks_front = {
    name                 = "pe-front-app-dev-uks-001"
    rg_key               = "network-uks"
    vnet_key             = "vnet-uks"
    snet_key             = "pe"
    dns_key              = "app_dns"
    resource             = "front_svc"
    is_manual_connection = false
    subresource_names    = ["sites"]
    request_message      = ""
  }
  pe_uks_back = {
    name                 = "pe-back-app-dev-uks-001"
    rg_key               = "network-uks"
    vnet_key             = "vnet-uks"
    snet_key             = "pe"
    dns_key              = "app_dns"
    resource             = "back_svc"
    is_manual_connection = false
    subresource_names    = ["sites"]
    request_message      = ""
  }
}

private_dns = {
  kv_dns = {
    name   = "privatelink.vaultcore.azure.net"
    rg_key = "network-uks"
  }
  storage_dns = {
    name   = "privatelink.blob.core.windows.net"
    rg_key = "network-uks"
  }
  acr_dns = {
    name   = "privatelink.azurecr.io"
    rg_key = "network-uks"
  }
  app_dns = {
    name   = "privatelink.azurewebsites.net"
    rg_key = "network-uks"
  }
}

app_insights = {
  name   = "appinsight-app-dev-uks-001"
  rg_key = "default-uks"
}

log_analytics_workspace = {
  name     = "la-app-dev-uks-001"
  location = "UK South"
  rg_key   = "default-uks"
}

app_service_plan = {
  name   = "appservice-apps-dev-eastus-001"
  rg_key = "default-uks"
}

frontend = {
  name                          = "front-app-dev-uks-001"
  rg_key                        = "default-uks"
  vnet_key                      = "vnet-uks"
  snet_key                      = "app_service"
  env                           = "dev"
  docker_image_tag              = "latest"
  public_network_access_enabled = false
  require_assignment            = true
}

backend = {
  name                          = "back-app-dev-uks-001"
  rg_key                        = "default-uks"
  vnet_key                      = "vnet-uks"
  snet_key                      = "app_service"
  env                           = "dev"
  docker_image_tag              = "latest"
  public_network_access_enabled = false
  require_assignment            = true
}

postgresql_flexible_server_name = "psqlsrv-app-dev-uks-001"
postgres_zone                   = 1
size                            = "D8ds_v4"
postgres_storage_mb             = "32768"
administrator_login             = "tstpostgresqladmin"
postgres_sku_name               = "GeneralPurpose"
postgresql_flexible_databases = {
  "martendb" = {
    charset   = "UTF8"
    collation = "en_US.utf8"
  }
}
geo_redundant_backup_enabled = true
backup_retention_days        = 30
