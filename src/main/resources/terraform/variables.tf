variable "AZ_RESOURCE_GROUP" {
  type     = string
  nullable = false
}

variable "AZ_LOCATION" {
  type     = string
  nullable = false
  default  = "eastus"
}

variable "AZ_CONTAINERAPP_ENV" {
  type     = string
  nullable = false
}

variable "AZ_CONTAINERAPP_NAME" {
  type     = string
  nullable = false
}

variable "ACR_NAME" {
  type     = string
  nullable = false
}

variable "ACR_RESOURCE_GROUP" {
  type     = string
  nullable = false
}

variable "ACR_MANAGED_IDENTITY" {
  type     = string
  nullable = false
}

variable "ACR_REGISTRY_SVR" {
  type     = string
  nullable = false
}

variable "DOCKER_ID" {
  type     = string
  nullable = false
  default  = "hecklerm"
}

variable "IMAGE_NAME" {
  type     = string
  nullable = false
}

variable "IMAGE_TAG" {
  type     = string
  nullable = false
  default  = "0.0.1-SNAPSHOT"
}
