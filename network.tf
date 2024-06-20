module "network" {
  for_each            = var.vnet_profile
  source              = "./modules/network"
  name                = each.value.name
  location            = module.resourcegroups[each.value.rg_key].rg_location
  resource_group_name = module.resourcegroups[each.value.rg_key].rg_name

  address_space    = each.value.address_space
  route_table_name = each.value.route_table_name
  routes           = each.value.routes
  subnets          = each.value.subnets
  tags             = local.tags
  depends_on = [
    module.resourcegroups
  ]
}
