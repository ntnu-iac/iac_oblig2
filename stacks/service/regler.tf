# Ekstra innkommende regler for denne tjenesten, i tillegg til allow-http fra
# modulen. Reglene står i service-<x>.tfvars, så de gjelder bare den tjenesten,
# og havner i samme state som resten av tjenesten.

resource "azurerm_network_security_rule" "ekstra" {
  for_each = var.ekstra_regler

  name                        = each.key
  resource_group_name         = local.net.resource_group_name
  network_security_group_name = module.subnet.nsg_name
  priority                    = each.value.priority
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = tostring(each.value.port)
  source_address_prefix       = each.value.source
  destination_address_prefix  = "*"
}
