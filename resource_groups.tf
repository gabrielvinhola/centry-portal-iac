module "resourcegroups" {
  for_each            = var.resource_groups
  source              = "./modules/resource_group"
  resource_group_name = "${each.value.prefix}-${local.name_suffix}-${each.value.location}-001"
  location            = each.value.location
  tags                = local.tags
}
