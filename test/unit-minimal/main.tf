# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# MINIMAL FEATURES UNIT TEST
# This module tests a minimal set of features.
# The purpose is to test all defaults for optional arguments and just provide the required arguments.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

variable "gcp_region" {
  type        = string
  description = "(Required) The gcp region in which all resources will be created."
}

variable "gcp_project" {
  type        = string
  description = "(Required) The ID of the project in which the resource belongs."
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.1"
    }
  }
}

provider "google" {
  region  = var.gcp_region
  project = var.gcp_project
}

data "google_compute_network" "default" {
  name = "default-europe-west3"
}

# DO NOT RENAME MODULE NAME
module "test" {
  source = "../.."

  # add only required arguments and no optional arguments
  name       = "terraform-google-gke-cluster-unit-minimal"
  network    = data.google_compute_network.default.self_link
  subnetwork = data.google_compute_network.default.subnetworks_self_links[0]
}

# outputs generate non-idempotent terraform plans so we disable them for now unless we need them.
# output "all" {
#   description = "All outputs of the module."
#   value       = module.test
# }
