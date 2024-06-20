locals {
  name_suffix = "${var.landing_zone}-${var.environment}"

  tags = {
    "Environment" : var.environment
  }
}