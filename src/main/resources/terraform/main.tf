terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.88.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "mkheck" {
  name     = var.AZ_RESOURCE_GROUP
  location = var.AZ_LOCATION
}

resource "azurerm_log_analytics_workspace" "mkheck" {
  name                = "${var.IMAGE_NAME}-law"
  location            = azurerm_resource_group.mkheck.location
  resource_group_name = azurerm_resource_group.mkheck.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "mkheck" {
  name                       = var.AZ_CONTAINERAPP_ENV
  location                   = azurerm_resource_group.mkheck.location
  resource_group_name        = azurerm_resource_group.mkheck.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.mkheck.id
}


data "azurerm_container_registry" "acr" {
  name                = var.ACR_NAME
  resource_group_name = var.ACR_RESOURCE_GROUP
}

resource "azurerm_user_assigned_identity" "mkheck" {
  location            = azurerm_resource_group.mkheck.location
  name                = var.ACR_MANAGED_IDENTITY
  resource_group_name = azurerm_resource_group.mkheck.name
}

resource "azurerm_role_assignment" "mkheck" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "acrpull"
  principal_id         = azurerm_user_assigned_identity.mkheck.principal_id
  depends_on = [
    azurerm_user_assigned_identity.mkheck
  ]
}


resource "azurerm_container_app" "mkheck" {
  name                         = var.AZ_CONTAINERAPP_NAME
  container_app_environment_id = azurerm_container_app_environment.mkheck.id
  resource_group_name          = azurerm_resource_group.mkheck.name
  revision_mode                = "Single"
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.mkheck.id]
  }

  registry {
    server = var.ACR_REGISTRY_SVR
    identity = azurerm_user_assigned_identity.mkheck.id
  }

  template {
    container {
      name   = var.AZ_CONTAINERAPP_NAME
      image  = "${var.ACR_REGISTRY_SVR}/${var.DOCKER_ID}/${var.IMAGE_NAME}:${var.IMAGE_TAG}"
      cpu    = 0.5
      memory = "1Gi"
    }
  }
}
