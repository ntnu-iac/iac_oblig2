output "resource_group_name" {
  description = "Ressursgruppa alle tjenestene står i."
  value       = azurerm_resource_group.this.name
}

output "resource_group_id" {
  description = "ID-en til ressursgruppa, for stacker som trenger å bygge ressurs-ID-er."
  value       = azurerm_resource_group.this.id
}

output "location" {
  description = "Regionen alt står i."
  value       = azurerm_resource_group.this.location
}

output "vnet_name" {
  description = "Navnet på VNet-et som tjenestenes subnett legges i."
  value       = module.vnet.name
}
