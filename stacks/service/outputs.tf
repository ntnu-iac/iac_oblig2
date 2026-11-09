output "subnet_id" {
  description = "Subnettet tjenesten står i."
  value       = module.subnet.subnet_id
}

output "storage_account_name" {
  description = "Storage account-en til tjenesten."
  value       = module.storage.name
}

output "key_vault_name" {
  description = "Key Vault-et til tjenesten."
  value       = module.keyvault.name
}

output "vm_public_ip" {
  description = "Offentlig IP når runtime er vm. Åpne http://<ip> for å se boot-id-en."
  value       = one([for v in module.vm : v.public_ip])
}

output "webapp_hostname" {
  description = "Adressen når runtime er webapp."
  value       = one([for w in module.webapp : w.hostname])
}
