# Proxmox Provider
# ---
# This file configures the Proxmox provider for Terraform.

# Enforce a minimum Terraform version and Proxmox provider version.
terraform {
  required_version = ">= 0.13.0"

  required_providers {
    proxmox = {
      source  = "terraform.local/telmate/proxmox"
      version = ">= 3.0.1"
    }
  }
}

# Define variables for the Proxmox API URL, token ID, and token secret.
variable "proxmox_api_url" {
  type        = string
  description = "The Proxmox API URL."
}

variable "proxmox_api_token_id" {
  type        = string
  description = "The Proxmox API token ID."
  sensitive   = true
}

variable "proxmox_api_token_secret" {
  type        = string
  description = "The Proxmox API token secret."
  sensitive   = true
}

variable "pm_tls_insecure" {
  type        = bool
  description = "If true, disables SSL/TLS certificate verification."
  default     = false
}

# Configure the Proxmox provider.
provider "proxmox" {
  pm_api_url            = var.proxmox_api_url
  pm_api_token_id       = var.proxmox_api_token_id
  pm_api_token_secret   = var.proxmox_api_token_secret
  pm_tls_insecure       = var.pm_tls_insecure
}
