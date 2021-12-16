resource "google_container_cluster" "cluster" {
  count = 1

  project    = var.project
  network    = var.network
  subnetwork = var.subnetwork

  name            = var.name
  description     = var.description
  resource_labels = var.resource_labels

  location       = var.location
  node_locations = var.node_locations


  dynamic "network_policy" {
    for_each = var.network_policy != null ? [var.network_policy] : []

    content {
      enabled  = network_policy.value.enabled
      provider = try(network_policy.value.provider, "CALICO")
    }
  }

  dynamic "release_channel" {
    for_each = var.release_channel != null ? [1] : []

    content {
      channel = var.release_channel
    }
  }

  # TODO: use data source to allow fuzzy version specification
  min_master_version = var.min_master_version

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  ### Node auto-provisioning

  dynamic "cluster_autoscaling" {
    for_each = can(var.cluster_autoscaling.enabled) ? [1] : []

    content {
      enabled = var.cluster_autoscaling.enabled

      resource_limits {
        resource_type = "cpu"
        minimum       = try(var.cluster_autoscaling.cpu.minimum, null)
        maximum       = try(var.cluster_autoscaling.cpu.maximum, null)
      }

      resource_limits {
        resource_type = "memory"
        minimum       = try(var.cluster_autoscaling.memory.minimum, null)
        maximum       = try(var.cluster_autoscaling.memory.maximum, null)
      }
    }
  }

  vertical_pod_autoscaling {
    enabled = var.vertical_pod_autoscaling_enabled
  }

  enable_shielded_nodes       = var.enable_shielded_nodes
  enable_binary_authorization = var.enable_binary_authorization

  ### Master authorized networks
  # From the documentation:
  #   The desired configuration options for master authorized networks.
  #   Omit the nested cidr_blocks attribute to disallow external access
  #   (except the cluster node IPs, which GKE automatically whitelists).
  #
  # null                              => no access limitation ? (TODO: verify this)
  # []                                => disallow external access (default)
  # [{cidr_block, display_name}, ...] => whitelist specific cidr_blocks

  dynamic "master_authorized_networks_config" {
    for_each = var.master_authorized_networks_cidr_blocks != null ? [1] : []

    content {
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks_cidr_blocks

        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = try(cidr_blocks.value.display_name, null)
        }
      }
    }
  }

  ### Configure addons

  addons_config {
    http_load_balancing {
      disabled = !var.addon_http_load_balancing
    }

    horizontal_pod_autoscaling {
      disabled = !var.addon_horizontal_pod_autoscaling
    }

    network_policy_config {
      disabled = !var.addon_network_policy_config
    }
  }

  ### VPC_NATIVE configuration

  cluster_ipv4_cidr         = null
  default_max_pods_per_node = var.default_max_pods_per_node

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  # TODO: support more options
  maintenance_policy {
    daily_maintenance_window {
      start_time = var.maintenance_start_time
    }
  }

  ### Remove default node-pool after initial creation
  # We create the smallest possible default node-pool and delete it right away
  # there is no way not to create the default node pool.
  # node pools should be created using the terraform-google-gke-node-pool module
  # for regional clusters thsi will create 1 node in each zone of the region

  # node_pool {}
  initial_node_count       = 1
  remove_default_node_pool = true

  ### Resource usage export to Bigquery
  dynamic "resource_usage_export_config" {
    for_each = var.resource_usage_export_bigquery_dataset_id != null ? [1] : []

    content {
      enable_network_egress_metering       = var.enable_network_egress_metering
      enable_resource_consumption_metering = var.enable_resource_consumption_metering

      bigquery_destination {
        dataset_id = var.resource_usage_export_bigquery_dataset_id
      }
    }
  }

  ### private cluster config
  # From the provider documentation:
  #   The Google provider is unable to validate certain configurations of private_cluster_config
  #   when enable_private_nodes is false.
  #   It's recommended that you omit the block entirely if the field is not set to true.
  dynamic "private_cluster_config" {
    for_each = var.enable_private_nodes ? [1] : []

    content {
      enable_private_endpoint = var.enable_private_endpoint
      enable_private_nodes    = var.enable_private_nodes
      master_ipv4_cidr_block  = var.master_ipv4_cidr_block
    }
  }

  ### Encryption-at-rest configuration
  dynamic "database_encryption" {
    for_each = var.database_encryption_key_name != null ? [1] : []

    content {
      key_name = var.database_encryption_key_name
      state    = var.database_encryption_key_name != "" ? "ENCRYPTED" : "DECRYPTED"
    }
  }

  workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }

  lifecycle {
    ignore_changes = [
      node_pool,
      initial_node_count,
    ]
  }

  timeouts {
    create = "45m"
    update = "45m"
    delete = "45m"
  }

  depends_on = []
}
