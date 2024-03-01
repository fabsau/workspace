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

# Define variables for the Proxmox API URL, user and password.
variable "proxmox_api_url" {
  type        = string
  description = "The Proxmox API URL."
}

variable "proxmox_user" {
  type        = string
  description = "The Proxmox username."
}

variable "proxmox_password" {
  type        = string
  description = "The Proxmox password."
  sensitive   = true
}

variable "pm_tls_insecure" {
  type        = bool
  description = "If true, disables SSL/TLS certificate verification."
  default     = false
}

# Configure the Proxmox provider.
provider "proxmox" {
  pm_api_url       = var.proxmox_api_url
  pm_user          = var.proxmox_user
  pm_password      = var.proxmox_password
  pm_tls_insecure  = var.pm_tls_insecure
}
