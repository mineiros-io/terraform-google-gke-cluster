# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# COMPLETE FEATURES UNIT TEST
# This module tests a complete set of most/all non-exclusive features
# The purpose is to activate everything the module offers, but trying to keep execution time and costs minimal.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

variable "project" {
  type        = string
  description = "(Required) The ID of the project in which the resource belongs."
}

variable "region" {
  type        = string
  description = "(Optional) The GCP region to create all resources in."
  default     = "europe-west3"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

# Networking

locals {
  vpc_name = "terraform-google-gke-cluster-unit-complete"
  subnet = {
    name       = local.vpc_name
    cidr_range = "10.4.0.0/20"
    secondary_ip_ranges = {
      pods = {
        name       = "terraform-google-gke-cluster-unit-complete-pods"
        cidr_range = "10.4.128.0/17"
      }
      services = {
        name       = "terraform-google-gke-cluster-unit-complete-services"
        cidr_range = "10.4.112.0/20"
      }
    }
  }
}

module "vpc" {
  source = "github.com/mineiros-io/terraform-google-network-vpc?ref=v0.0.2"

  project                         = var.project
  name                            = local.vpc_name
  delete_default_routes_on_create = false
}

module "subnetwork" {
  source = "github.com/mineiros-io/terraform-google-network-subnet?ref=v0.0.2"

  network = module.vpc.vpc.self_link
  project = var.project

  subnets = [
    {
      name                     = local.subnet.name
      region                   = var.region
      ip_cidr_range            = local.subnet.cidr_range
      private_ip_google_access = true

      secondary_ip_ranges = [
        {
          range_name    = local.subnet.secondary_ip_ranges.pods.name
          ip_cidr_range = local.subnet.secondary_ip_ranges.pods.cidr_range
        },
        {
          range_name    = local.subnet.secondary_ip_ranges.services.name
          ip_cidr_range = local.subnet.secondary_ip_ranges.services.cidr_range
        }
      ]
    }
  ]
}

# module "router-nat" {
#   source = "github.com/mineiros-io/terraform-google-cloud-router?ref=v0.0.2"

#   name    = "terraform-google-gke-cluster-unit-complete"
#   project = var.project
#   region  = var.region
#   network = module.vpc.vpc.self_link

#   nats = [{
#     name = "terraform-google-gke-cluster-unit-complete"
#   }]
# }

# DO NOT RENAME MODULE NAME
module "test" {
  source = "../.."

  module_enabled = true

  # add all required arguments
  name       = "gke-unit-complete"
  network    = module.vpc.vpc.self_link
  subnetwork = module.subnetwork.subnetworks["${var.region}/${local.subnet.name}"].self_link

  # add all optional arguments that create additional resources

  # add most/all other optional arguments
  node_locations = [
    "${var.region}-a",
    "${var.region}-b",
  ]

  master_ipv4_cidr_block = "10.4.96.0/28"

  ip_allocation_policy = {
    cluster_secondary_range_name  = local.subnet.secondary_ip_ranges.pods.name
    services_secondary_range_name = local.subnet.secondary_ip_ranges.services.name
  }

  location = var.region # creates a regional cluster, for details please see https://cloud.google.com/kubernetes-engine/docs/concepts/types-of-clusters

  maintenance_policy = {
    recurring_window = {
      start_time = "2022-01-01T00:00:00Z"
      end_time   = "2030-01-02T00:00:00Z"
      recurrence = "FREQ=DAILY"
    }
    maintenance_exclusions = [
      {
        exclusion_name = "batch job"
        start_time     = "2025-01-01T00:00:00Z"
        end_time       = "2025-01-02T00:00:00Z"
      },
      {
        exclusion_name = "holiday data load"
        start_time     = "2025-05-01T00:00:00Z"
        end_time       = "2025-05-02T00:00:00Z"
      }
    ]
  }

  module_timeouts = {
    google_container_cluster = {
      create = "40m"
      update = "45m"
      delete = "50m"
    }
  }

  module_depends_on = ["nothing"]
}

# outputs generate non-idempotent terraform plans so we disable them for now unless we need them.
# output "all" {
#   description = "All outputs of the module."
#   value       = module.test
# }
