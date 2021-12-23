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

locals {
  name                          = "gke-unit-minimal"
  cluster_secondary_range_name  = "${local.name}-pods"
  services_secondary_range_name = "${local.name}-services"

  node_pools_cidr_block = "10.0.0.0/20"
  pods_cidr_block       = "10.10.0.0/20"
  services_cidr_block   = "10.20.0.0/20"
  master_cidr_block     = "10.1.0.0/28"
}

module "vpc" {
  source = "github.com/mineiros-io/terraform-google-network-vpc.git?ref=v0.0.2"

  project                         = var.gcp_project
  name                            = local.name
  delete_default_routes_on_create = false
}

module "subnetworks" {
  source = "github.com/mineiros-io/terraform-google-network-subnet.git?ref=v0.0.2"

  project = var.gcp_project
  network = module.vpc.vpc.self_link
  subnets = [
    {
      _resource_key            = local.node_pools_cidr_block
      name                     = local.name
      region                   = var.gcp_region
      private_ip_google_access = true,
      ip_cidr_range            = local.node_pools_cidr_block
      secondary_ip_ranges = [
        {
          range_name    = local.cluster_secondary_range_name
          ip_cidr_range = local.pods_cidr_block
        },
        {
          range_name    = local.services_secondary_range_name
          ip_cidr_range = local.services_cidr_block
        }
      ]
    }
  ]
}

module "router-nat" {
  source = "github.com/mineiros-io/terraform-google-cloud-router?ref=v0.0.2"

  name    = local.name
  project = var.gcp_project
  region  = var.gcp_region
  network = module.vpc.vpc.self_link

  nats = [
    {
      name = local.name
    }
  ]
}

# DO NOT RENAME MODULE NAME
module "test" {
  source = "../.."

  # add only required arguments and no optional arguments
  name       = local.name
  network    = module.vpc.vpc.self_link
  subnetwork = module.subnetworks.subnetworks[local.node_pools_cidr_block].self_link

  enable_private_nodes = false
}

# outputs generate non-idempotent terraform plans so we disable them for now unless we need them.
# output "all" {
#   description = "All outputs of the module."
#   value       = module.test
# }
