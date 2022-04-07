header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-google-gke-cluster"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-google-gke-cluster/workflows/Tests/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-google-gke-cluster/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-gke-cluster.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-google-gke-cluster/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-gcp-provider" {
    image = "https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-google/releases"
    text  = "Google Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-google-gke-cluster"
  toc     = true
  content = <<-END
    A [Terraform](https://www.terraform.io) module to create and manage a Google
    Kubernetes Engine (GKE) cluster.

    **_This module supports Terraform version 1
    and is compatible with the Terraform Google Provider version 4._**

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
      This module implements the following Terraform resources

      - `google_container_cluster`
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most common usage of the module:

      ```hcl
      module "terraform-google-gke-cluster" {
        source = "git@github.com:mineiros-io/terraform-google-gke-cluster.git?ref=v0.0.2"

        project            = "project-id"
        location           = "region"
        network            = "name-of-network"
        subnetwork         = "name-of-subnet"
        name               = "name-of-cluster"
        min_master_version = "min-version"

        cluster_secondary_range_name  = "range-name"
        services_secondary_range_name = "range-name"

        master_ipv4_cidr_block = "ip-range"
      }
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Main Resource Configuration"

      variable "name" {
        required    = true
        type        = string
        description = <<-END
          The name of the cluster.
        END
      }

      variable "location" {
        type        = string
        description = <<-END
          The location (region or zone) in which the cluster master will be
          created, as well as the default node location. If you specify a zone
          (such as `us-central1-a`), the cluster will be a zonal cluster with
          a single cluster master. If you specify a region (such as `us-west1`),
          the cluster will be a regional cluster with multiple masters spread
          across zones in the region, and with default node locations in those zones as well.
          For the differences between zonal and regional clusters, please see
          https://cloud.google.com/kubernetes-engine/docs/concepts/types-of-clusters
        END
      }

      variable "network" {
        type        = string
        description = <<-END
          The name or `self_link` of the Google Compute Engine network to which
          the cluster is connected. For Shared VPC, set this to the self link of
          the shared network.
        END
      }

      variable "subnetwork" {
        type        = string
        description = <<-END
          The name or `self_link` of the Google Compute Engine subnetwork in which
          the cluster's instances are launched.
        END
      }

      variable "networking_mode" {
        type        = string
        default     = "VPC_NATIVE"
        description = <<-END
          Determines whether alias IPs or routes will be used for pod IPs in
          the cluster. Options are `VPC_NATIVE` or `ROUTES`. `VPC_NATIVE`
          enables IP aliasing, and requires the `ip_allocation_policy` block to
          be defined.
        END
      }

      variable "project" {
        type        = string
        description = <<-END
          The ID of the project in which the resource belongs.
          If it is not set, the provider project is used.
        END
      }

      variable "rbac_security_identity_group" {
        type        = string
        description = <<-END
          The name of the RBAC security identity group for use with Google
          security groups in Kubernetes RBAC. Group name must be in format
          `gke-security-groups@yourdomain.com`.
          For details please see
          https://cloud.google.com/kubernetes-engine/docs/how-to/google-groups-rbac
        END
      }

      variable "min_master_version" {
        type        = string
        description = <<-END
          The Kubernetes minimal version of the masters. If set to `latest` it
          will pull latest available version in the selected region.
        END
      }

      variable "cluster_ipv4_cidr" {
        type        = string
        description = <<-END
          The IP address range of the Kubernetes pods in this cluster in CIDR
          notation (e.g. `10.96.0.0/14`). Leave blank to have one automatically
          chosen or specify a `/14` block in `10.0.0.0/8`.
          **Note:** This field will only work for routes-based clusters, where
          `ip_allocation_policy` is not defined.
        END
      }

      variable "ip_allocation_policy" {
        type = object(ip_allocation_policy)
        description = <<-END
          Configuration of cluster IP allocation for VPC-native clusters.
          Adding this block enables IP aliasing, making the cluster VPC-native
          instead of routes-based.
        END
        readme_example = <<-END
          readme_example = {
            cluster_ipv4_cidr_block  = "10.4.128.0/17"
            services_ipv4_cidr_block = "10.4.112.0/20"
          }
        END

        attribute "cluster_ipv4_cidr_block" {
          type        = string
          description = <<-END
            The IP address range for the cluster pod IPs.
            Set to blank to have a range chosen with the default size.
            Set to /netmask (e.g. `/14`) to have a range chosen with a specific netmask.
            Set to a CIDR notation (e.g. `10.96.0.0/14`) from the RFC-1918
            private networks (e.g. `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`)
            to pick a specific range to use.
            Conflicts with `cluster_secondary_range_name`.
          END
        }

        attribute "services_ipv4_cidr_block" {
          type        = string
          description = <<-END
            The IP address range of the services IPs in this cluster.
            Set to blank to have a range chosen with the default size.
            Set to /netmask (e.g. `/14`) to have a range chosen with a specific
            netmask. Set to a CIDR notation (e.g. `10.96.0.0/14`) from the
            RFC-1918 private networks (e.g. `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`)
            to pick a specific range to use.
            Conflicts with `cluster_secondary_range_name`.
          END
        }

        attribute "cluster_secondary_range_name" {
          type        = string
          description = <<-END
            The name of the existing secondary range in the cluster's subnetwork
            to use for pod IP addresses. Alternatively, `cluster_ipv4_cidr_block`
            can be used to automatically create a GKE-managed one.
            Conflicts with `cluster_ipv4_cidr_block`.
          END
        }

        attribute "services_secondary_range_name" {
          type        = string
          description = <<-END
            The name of the existing secondary range in the cluster's subnetwork
            to use for service `ClusterIPs`. Alternatively, `services_ipv4_cidr_block`
            can be used to automatically create a GKE-managed one.
            Conflicts with `services_ipv4_cidr_block`.
          END
        }
      }

      variable "description" {
        type        = string
        default     = ""
        description = <<-END
          The description of the cluster.
        END
      }

      variable "node_locations" {
        type        = set(string)
        default     = []
        description = <<-END
          A set of zones in which the cluster's nodes are located.
          Nodes must be in the region of their regional cluster or in the same
          region as their cluster's zone for zonal clusters.
          If this is specified for a zonal cluster, omit the cluster's zone.
        END
      }

      variable "master_authorized_networks_config" {
        type = object(master_authorized_networks_config)
        description = <<-END
          Configuration for handling external access control plane of the cluster.
        END
        readme_example = <<-END
          master_authorized_networks_config = {
            cidr_blocks = [
              {
                display_name = "Berlin Office"
                cidr_block   = "10.4.112.0/20"
              }
            ]
          }
        END

        attribute "cidr_blocks" {
          type        = list(cidr_block)
          default     = []
          description = <<-END
            Set of master authorized networks. If none are provided, disallow
            external access (except the cluster node IPs, which GKE automatically
            whitelists).
          END

          attribute "cidr_block" {
            required    = true
            type        = string
            description = <<-END
              External network that can access Kubernetes master through HTTPS.
              Must be specified in CIDR notation.
            END
          }

          attribute "display_name" {
            type        = string
            description = <<-END
              Field for users to identify CIDR blocks.
            END
          }
        }
      }

      variable "enabled_vertical_pod_autoscaling" {
        type        = bool
        default     = false
        description = <<-END
          If enabled, Vertical Pod Autoscaling automatically adjusts the
          resources of pods controlled by it.
        END
      }

      variable "addon_horizontal_pod_autoscaling" {
        type        = bool
        default     = true
        description = <<-END
          Whether to enable the horizontal pod autoscaling addon.
        END
      }

      variable "addon_http_load_balancing" {
        type        = bool
        default     = true
        description = <<-END
          Whether to enable the httpload balancer addon.
        END
      }

      variable "addon_network_policy_config" {
        type        = bool
        default     = false
        description = <<-END
          Whether to enable the network policy addon.
        END
      }

      variable "addon_network_policy_config" {
        type        = bool
        default     = false
        description = <<-END
          Whether to enable the network policy addon.
        END
      }

      variable "addon_filestore_csi_driver" {
        type        = bool
        default     = false
        description = <<-END
          Whether to enable the Filestore CSI driver addon, which allows the
          usage of filestore instance as volumes.
        END
      }

      variable "network_policy" {
        type        = object(network_policy)
        description = <<-END
          Configuration options for the NetworkPolicy feature.
        END

        attribute "enabled" {
          type        = bool
          default     = false
          description = <<-END
            Whether network policy is enabled on the cluster.
          END
        }

        attribute "provider" {
          type        = string
					default     = "CALICO"
          description = <<-END
            The selected network policy provider.
          END
        }
      }

      variable "maintenance_policy" {
        type        = object(maintenance_policy)
        description = <<-END
          The maintenance policy to use for the cluster.
        END

        attribute "daily_maintenance_window" {
          type        = object(daily_maintenance_window)
          description = <<-END
            Time window specified for daily maintenance operations.
            For details please see https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#daily_maintenance_window
          END
          readme_example = <<-END
            maintenance_policy = {
              daily_maintenance_window = {
                start_time = "03:00"
              }
            }
          END

          attribute "start_time" {
            required    = true
            type        = string
            description = <<-END
              Specify the `start_time` for a daily maintenance window in
              RFC3339 format `HH:MM`, where HH : [00-23] and MM : [00-59] GMT.
            END
          }
        }

        attribute "recurring_window" {
          type        = object(recurring_window)
          description = <<-END
            Time window specified for recurring maintenance operations.
            For details please see https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#recurring_window
          END
          readme_example = <<-END
            maintenance_policy = {
              recurring_window = {
                start_time = "2022-01-01T09:00:00Z"
                end_time   = "2022-01-01T17:00:00Z"
                recurrence = "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR"
              }
            }
          END

          attribute "start_time" {
            required    = true
            type        = string
            description = <<-END
              Specify `start_time` and in RFC3339 "Zulu" date format.
              The start time's date is the initial date that the window starts.
            END
          }

          attribute "end_time" {
            required    = true
            type        = string
            description = <<-END
              Specify `end_time` in RFC3339 "Zulu" date format.
              The end time is used for calculating duration.
            END
          }

          attribute "recurrence" {
            required    = true
            type        = string
            description = <<-END
              Specify recurrence in [RFC5545](https://datatracker.ietf.org/doc/html/rfc5545#section-3.8.5.3)
              RRULE format, to specify when this maintenance window recurs.
            END
          }
        }

        attribute "maintenance_exclusion" {
          type        = list(maintenance_exclusion)
          description = <<-END
            Exceptions to maintenance window. Non-emergency maintenance should
            not occur in these windows. A cluster can have up to three
            maintenance exclusions at a time.
            For details please see https://cloud.google.com/kubernetes-engine/docs/concepts/maintenance-windows-and-exclusions
          END
          readme_example = <<-END
            maintenance_policy = {
              recurring_window = {
                start_time = "2022-01-01T00:00:00Z"
                end_time   = "2022-01-02T00:00:00Z"
                recurrence = "FREQ=DAILY"
              }
              maintenance_exclusion = {
                exclusion_name = "batch job"
                start_time     = "2022-01-01T00:00:00Z"
                end_time       = "2022-01-02T00:00:00Z"
              }
              maintenance_exclusion = {
                exclusion_name = "holiday data load"
                start_time     = "2022-05-01T00:00:00Z"
                end_time       = "2022-05-02T00:00:00Z"
              }
            }
          END

          attribute "exclusion_name" {
            required    = true
            type        = string
            description = <<-END
              The name of the maintenance exclusion window.
            END
          }

          attribute "start_time" {
            required    = true
            type        = string
            description = <<-END
              Specify `start_time` and in RFC3339 "Zulu" date format.
              The start time's date is the initial date that the window starts.
            END
          }

          attribute "end_time" {
            required    = true
            type        = string
            description = <<-END
              Specify `end_time` in RFC3339 "Zulu" date format.
              The end time is used for calculating duration.
            END
          }
        }
      }

      variable "resource_usage_export_bigquery_dataset_id" {
        type        = string
        description = <<-END
          The ID of a BigQuery Dataset for using BigQuery as the destination of
          resource usage export.
        END
      }

      variable "enable_confidential_nodes" {
        type        = bool
        default     = false
        description = <<-END
          Whether to enable Confidential Nodes for this cluster.
        END
      }

      variable "enable_network_egress_metering" {
        type        = bool
        default     = false
        description = <<-END
          Whether to enable network egress metering for this cluster. If
          enabled, a daemonset will be created in the cluster to meter network
          egress traffic.
        END
      }

      variable "enable_resource_consumption_metering" {
        type        = bool
        default     = true
        description = <<-END
          Whether to enable resource consumption metering on this cluster. When
          enabled, a table will be created in the resource export BigQuery
          dataset to store resource consumption data. The resulting table can be
          joined with the resource usage table or with BigQuery billing export.
        END
      }

      variable "cluster_autoscaling" {
        type        = object(cluster_autoscaling)
				default     = false
        description = <<-END
          Cluster autoscaling configuration. For details please see
          https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling
        END

        attribute "enabled" {
          type        = bool
          default     = false
          description = <<-END
            Whether node auto-provisioning is enabled. Resource limits for cpu
            and memory must be defined to enable node auto-provisioning.
          END
        }

        attribute "cpu" {
          type        = object(cpu)
          description = <<-END
            Global constraints for CPU machine resources in the cluster.
            Configuring this is required if node auto-provisioning is enabled.
            These limits will apply to node pool autoscaling in addition to
            node auto-provisioning.
          END

          attribute "minimum" {
            type        = number
            description = <<-END
              Minimum amount of CPU resources in the cluster.
            END
          }

          attribute "maximum" {
            type        = number
            description = <<-END
              Maximum amount of CPU resources in the cluster.
            END
          }
        }

        attribute "memory" {
          type        = object(memory)
          description = <<-END
            Global constraints for Memory resources in the cluster. Configuring
            this is required if node auto-provisioning is enabled. These limits
            will apply to node pool autoscaling in addition to node auto-provisioning.
          END

          attribute "minimum" {
            type        = number
            description = <<-END
              Minimum amount of memory resources in the cluster.
            END
          }

          attribute "maximum" {
            type        = number
            description = <<-END
              Maximum amount of memory resources in the cluster.
            END
          }
        }

        attribute "auto_provisioning_defaults" {
          type        = object(auto_provisioning_default)
          description = <<-END
            Contains defaults for a node pool created by NAP.
          END

          attribute "oauth_scopes" {
            type        = list(string)
            description = <<-END
              Scopes that are used by NAP when creating node pools. Use the
              https://www.googleapis.com/auth/cloud-platform scope to grant
              access to all APIs. It is recommended that you set
              `service_account` to a non-default service account and grant IAM
              roles to that service account for only the resources that it needs.
            END
          }

          attribute "service_account" {
            type        = string
            description = <<-END
              The Google Cloud Platform Service Account to be used by the node VMs.
            END
          }
        }
      }

      variable "logging_enable_components" {
        type        = set(string)
        description = <<-END
          A list of GKE components exposing logs.
          Supported values include: `SYSTEM_COMPONENTS` and `WORKLOADS`.
        END
      }

      variable "logging_service" {
        type        = string
        default     = "logging.googleapis.com/kubernetes"
        description = <<-END
          The logging service that the cluster should write logs to. Available
          options include `logging.googleapis.com`, and `none`.
        END
      }

      variable "monitoring_enable_components" {
        type        = set(string)
        description = <<-END
          A list of GKE components exposing logs.
          Supported values include: `SYSTEM_COMPONENTS` and `WORKLOADS`.
        END
      }

      variable "monitoring_service" {
        type        = string
        default     = "monitoring.googleapis.com/kubernetes"
        description = <<-END
          The monitoring service that the cluster should write metrics to.
          Automatically send metrics from pods in the cluster to the Google
          Cloud Monitoring API. VM metrics will be collected by Google Comput
          Engine regardless of this setting Available options include
          `monitoring.googleapis.com`, and `none`.
        END
      }

      variable "resource_labels" {
        type        = map(string)
        default     = {}
        description = <<-END
          The GCE resource labels (a map of key/value pairs) to be applied to
          the cluster.
        END
      }

      variable "default_max_pods_per_node" {
        type        = number
        default     = 110
        description = <<-END
          The maximum number of pods to schedule per node.
        END
      }

      variable "enable_intranode_visibility" {
        type        = bool
        default     = false
        description = <<-END
          Whether Intra-node visibility is enabled for this cluster.
          This makes same node pod to pod traffic visible for VPC network.
        END
      }

      variable "enable_private_endpoint" {
        type        = bool
        default     = false
        description = <<-END
          Whether the master's internal IP address is used as the cluster endpoint.
        END
      }

      variable "enable_private_nodes" {
        type        = bool
        default     = true
        description = <<-END
          Whether nodes have internal IP addresses only.
        END
      }

      variable "private_ipv6_google_access" {
        type        = string
        description = <<-END
          Configures the IPv6 connectivity to Google Services.
          By default, no private IPv6 access to or from Google Services is
          enabled (all access will be via IPv4).
          Accepted values are `PRIVATE_IPV6_GOOGLE_ACCESS_UNSPECIFIED`,
          `INHERIT_FROM_SUBNETWORK`, `OUTBOUND`, and `BIDIRECTIONAL`.
        END
      }

      variable "master_ipv4_cidr_block" {
        type        = string
        description = <<-END
          The IP range in CIDR notation to use for the hosted master network.
        END
      }

      variable "database_encryption_key_name" {
        type        = string
        description = <<-END
          The name of a CloudKMS key to enable application-layer secrets
          encryption settings. If non-null the state will be set to:
          `ENCRYPTED` else `DECRYPTED`.
        END
      }

      variable "release_channel" {
        type        = string
        default     = "UNSPECIFIED"
        description = <<-END
          The release channel of this cluster. Accepted values are
          `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`.
        END
      }

      variable "enable_shielded_nodes" {
        type        = bool
        default     = true
        description = <<-END
          Whether to enable Shielded Nodes features on all nodes in this cluster.
        END
      }

      variable "enable_binary_authorization" {
        type        = bool
        default     = false
        description = <<-END
          Whether to enable BinAuthZ Admission controller.
        END
      }
    }

    section {
      title = "Module Configuration"

      variable "module_enabled" {
        type        = bool
        default     = true
        description = <<-END
          Specifies whether resources in the module will be created.
        END
      }

      variable "module_timeouts" {
        type           = map(timeout)
        description    = <<-END
          A map of timeout objects that is keyed by Terraform resource name
          defining timeouts for `create`, `update` and `delete` Terraform operations.

          Supported resources are: `google_container_cluster`, ...
        END
        readme_example = <<-END
          module_timeouts = {
            google_container_cluster = {
              create = "60m"
              update = "60m"
              delete = "60m"
            }
          }
        END

        attribute "create" {
          type        = string
          description = <<-END
            Timeout for create operations.
          END
        }

        attribute "update" {
          type        = string
          description = <<-END
            Timeout for update operations.
          END
        }

        attribute "delete" {
          type        = string
          description = <<-END
            Timeout for delete operations.
          END
        }
      }

      variable "module_depends_on" {
        type           = list(dependency)
        description    = <<-END
          A list of dependencies.
          Any object can be _assigned_ to this list to define a hidden external dependency.
        END
        default        = []
        readme_example = <<-END
          module_depends_on = [
            null_resource.name
          ]
        END
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported in the outputs of the module:
    END

    output "name" {
      type        = string
      description = <<-END
        The name of the cluster.
      END
    }

    output "cluster" {
      type        = object(cluster)
      description = <<-END
        All arguments in `google_container_cluster`.
      END
    }

    output "module_enabled" {
      type        = bool
      description = <<-END
          Whether this module is enabled.
        END
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "Google Documentation"
      content = <<-END
        - https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-architecture
      END
    }

    section {
      title   = "Terraform GCP Provider Documentation"
      content = <<-END
        - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#nested_cluster_autoscaling
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-google-gke-cluster"
  }
  ref "hello@mineiros.io" {
    value = " mailto:hello@mineiros.io"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "releases-aws-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-aws/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://mineiros.io/slack"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "aws" {
    value = "https://aws.amazon.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-google-gke-cluster/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-google-gke-cluster/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-google-gke-cluster/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-google-gke-cluster/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-google-gke-cluster/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-google-gke-cluster/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-google-gke-cluster/blob/main/CONTRIBUTING.md"
  }
}
