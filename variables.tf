variable "subscription_id" {
  type        = "string"
  description = "The Azure Subscription ID"
}

variable "client_id" {
  type        = "string"
  description = "The Azure Client ID"
}

variable "client_secret" {
  type        = "string"
  description = "The Azure client secret"
}

variable "tenant_id" {
  type        = "string"
  description = "The Azure tenant ID"
}

variable "location" {
  type        = "string"
  description = "The region in which to deploy the VM"
  default     = "East Us"
}
