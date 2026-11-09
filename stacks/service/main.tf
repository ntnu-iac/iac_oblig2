# ÉN tjeneste: subnett med NSG, storage account, Key Vault og et kjøremiljø.
# Tjenesten er en parameter, ikke en mappe. Hver config/<miljø>/service-<x>.tfvars
# er én instans av denne stacken, med sin egen state-fil.
#
# runtime velger kjøremiljøet: "vm" gir en Linux-VM med offentlig IP, "webapp"
# gir en App Service-plan og en web app med VNet-integrasjon (modul 9 side 5).

data "azurerm_client_config" "current" {}

data "terraform_remote_state" "shared_network" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.state_resource_group_name
    storage_account_name = var.state_storage_account_name
    container_name       = var.state_container_name
    key                  = "oblig2/${var.miljo}/shared-network.tfstate"
    use_azuread_auth     = true
  }
}

locals {
  net = data.terraform_remote_state.shared_network.outputs

  # Brukes som for_each på kjøremiljøet. Nøkkelen er det samme ordet som
  # runtime, så adressen blir module.vm["vm"] eller module.webapp["webapp"].
  vm     = var.runtime == "vm" ? toset(["vm"]) : toset([])
  webapp = var.runtime == "webapp" ? toset(["webapp"]) : toset([])

  tags = {
    eier  = var.kortnavn
    miljo = var.miljo
    kurs  = "dcst3005-oblig2"
  }
}

module "subnet" {
  source = "../../modules/subnet"

  service             = var.tjeneste
  resource_group_name = local.net.resource_group_name
  location            = var.location
  vnet_name           = local.net.vnet_name
  prefix              = var.prefix
  delegate_web        = var.runtime == "webapp"
  allow_http_from     = var.allow_http_from
  tags                = local.tags
}

module "storage" {
  source = "../../modules/storage"

  service             = var.tjeneste
  kortnavn            = var.kortnavn
  miljo               = var.miljo
  resource_group_name = local.net.resource_group_name
  location            = var.location
  tags                = local.tags
}

module "keyvault" {
  source = "../../modules/keyvault"

  service             = var.tjeneste
  kortnavn            = var.kortnavn
  miljo               = var.miljo
  resource_group_name = local.net.resource_group_name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = local.tags
}

module "vm" {
  source   = "../../modules/vm"
  for_each = local.vm

  service             = var.tjeneste
  resource_group_name = local.net.resource_group_name
  location            = var.location
  subnet_id           = module.subnet.subnet_id
  size                = var.vm_size
  ssh_public_key      = var.ssh_public_key
  tags                = local.tags
}

module "webapp" {
  source   = "../../modules/webapp"
  for_each = local.webapp

  service             = var.tjeneste
  kortnavn            = var.kortnavn
  miljo               = var.miljo
  resource_group_name = local.net.resource_group_name
  location            = var.location
  subnet_id           = module.subnet.subnet_id
  sku                 = var.webapp_sku
  tags                = local.tags
}
