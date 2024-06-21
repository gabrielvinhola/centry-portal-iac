//data
data "azurerm_client_config" "current" {
}

data "http" "this" {
  url = "https://api.ipify.org/"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
  retry {
    attempts     = 5
    max_delay_ms = 30
    min_delay_ms = 30
  }
  depends_on = [null_resource.this]
}

resource "null_resource" "this" {
  triggers = {
    always_run = "${timestamp()}"
  }
}
