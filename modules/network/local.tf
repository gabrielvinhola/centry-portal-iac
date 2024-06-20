locals {
  route_table_inverted_map = tomap({
    for key, value in var.additional_route_tables : value.route_table_name => key
  })
}
