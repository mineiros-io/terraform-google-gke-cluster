variable "project" {
  type        = string
  description = "(Required) The ID of the project in which the resource belongs."
}

variable "location" {
  type        = string
  description = "(Required) The location (region or zone) in which the cluster master will be created."
}

variable "network" {
  type        = string
  description = "(Required) The name or self_link of the Google Compute Engine network to which the cluster is connected. For Shared VPC, set this to the self link of the shared network."
}

variable "subnetwork" {
  type        = string
  description = "(Required) The name or self_link of the Google Compute Engine subnetwork in which the cluster's instances are launched."
}

variable "name" {
  type        = string
  description = "(Required) The name of the cluster."
}

variable "min_master_version" {
  type        = string
  description = "(Required) The Kubernetes minimal version of the masters. If set to 'latest' it will pull latest available version in the selected region."
}

variable "cluster_secondary_range_name" {
  type        = string
  description = "(Required) The name of the secondary subnet ip range to use for pods."
}

variable "services_secondary_range_name" {
  type        = string
  description = "(Required) The name of the secondary subnet range to use for services."
}

variable "description" {
  type        = string
  description = "(Optional) The description of the cluster."
  default     = ""
}

variable "node_locations" {
  type        = set(string)
  description = "(Optional) A set of zones used for node locations."
  default     = []
}

variable "master_authorized_networks_cidr_blocks" {
  type        = any
  description = "(Optional) Set of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists)."
  default     = []
}

variable "vertical_pod_autoscaling_enabled" {
  type        = bool
  description = "(Optional) Vertical Pod Autoscaling automatically adjusts the resources of pods controlled by it."
  default     = false
}

variable "addon_horizontal_pod_autoscaling" {
  type        = bool
  description = "(Optional) Enable horizontal pod autoscaling addon."
  default     = true
}

variable "addon_http_load_balancing" {
  type        = bool
  description = "(Optional) Enable httpload balancer addon."
  default     = true
}

variable "addon_network_policy_config" {
  type        = bool
  description = "(Optional) Enable network policy addon."
  default     = false
}

variable "network_policy" {
  type        = any
  description = "(Optional) Configuration options for the NetworkPolicy feature."
  default     = null
}

variable "maintenance_start_time" {
  type        = string
  description = "(Optional) Time window specified for daily or recurring maintenance operations in RFC3339 format. Default is midnight UTC."
  default     = "00:00"
}

variable "resource_usage_export_bigquery_dataset_id" {
  type        = string
  description = "(Optional) The ID of a BigQuery Dataset for using BigQuery as the destination of resource usage export."
  default     = null
}

variable "enable_network_egress_metering" {
  type        = bool
  description = "(Optional) Whether to enable network egress metering for this cluster. If enabled, a daemonset will be created in the cluster to meter network egress traffic."
  default     = false
}

variable "enable_resource_consumption_metering" {
  type        = bool
  description = "(Optional) Whether to enable resource consumption metering on this cluster. When enabled, a table will be created in the resource export BigQuery dataset to store resource consumption data. The resulting table can be joined with the resource usage table or with BigQuery billing export."
  default     = true
}

variable "cluster_autoscaling" {
  type        = any
  description = "(Optional) Cluster autoscaling configuration. See [more details](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling)"
  default     = {}
}

variable "logging_service" {
  type        = string
  description = "(Optional) The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none"
  default     = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  type        = string
  description = "(Optional) The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none"
  default     = "monitoring.googleapis.com/kubernetes"
}

# variable "cluster_ipv4_cidr" {
#   type        = string
#   description = "(Optional) The IP address range of the kubernetes pods in this cluster. Default is an automatically assigned CIDR."
#   default     = null
# }

variable "resource_labels" {
  type        = map(string)
  description = "(Optional) The GCE resource labels (a map of key/value pairs) to be applied to the cluster"
  default     = {}
}

variable "default_max_pods_per_node" {
  description = "(Optional) The maximum number of pods to schedule per node"
  default     = 110
}

variable "enable_private_endpoint" {
  type        = bool
  description = "(Optional) Whether the master's internal IP address is used as the cluster endpoint"
  default     = false
}

variable "enable_private_nodes" {
  type        = bool
  description = "(Optional) Whether nodes have internal IP addresses only"
  default     = true
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "(Required) The IP range in CIDR notation to use for the hosted master network"
}

variable "database_encryption_key_name" {
  type        = string
  description = "(Optional) The name of a CloudKMS key to enable application-layer secrets encryption settings. If non-null the state will be set to: ENCRYPTED else DECRYPTED."
  default     = null
}

variable "release_channel" {
  type        = string
  description = "(Optional) The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `UNSPECIFIED`."
  default     = "UNSPECIFIED"
}

variable "enable_shielded_nodes" {
  type        = bool
  description = "(Optional) Enable Shielded Nodes features on all nodes in this cluster"
  default     = true
}

variable "enable_binary_authorization" {
  type        = bool
  description = "(Optional) Enable BinAuthZ Admission controller"
  default     = false
}

# ----------------------------------------------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ----------------------------------------------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not."
  default     = true
}

variable "module_timeouts" {
  description = "(Optional) How long certain operations (per resource type) are allowed to take before being considered to have failed."
  type        = any
  # type = object({
  #   google_container_cluster = optional(object({
  #     create = optional(string)
  #     update = optional(string)
  #     delete = optional(string)
  #   }))
  # })
  default = {}
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on."
  default     = []
}
