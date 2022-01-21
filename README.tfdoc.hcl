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
        source = "git@github.com:mineiros-io/terraform-google-gke-cluster.git?ref=v0.0.1"

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

      variable "project" {
        required    = true
        type        = string
        description = <<-END
          The ID of the project in which the resource belongs.
        END
      }

      variable "location" {
        required    = true
        type        = string
        description = <<-END
          The location (region or zone) in which the cluster master will be
          created.
        END
      }

      variable "network" {
        required    = true
        type        = string
        description = <<-END
          The name or `self_link` of the Google Compute Engine network to which
          the cluster is connected. For Shared VPC, set this to the self link of
          the shared network.
        END
      }

      variable "subnetwork" {
        required    = true
        type        = string
        description = <<-END
          The name or self_link of the Google Compute Engine subnetwork in which
          the cluster's instances are launched.
        END
      }

      variable "name" {
        required    = true
        type        = string
        description = <<-END
          The name of the cluster.
        END
      }

      variable "rbac_security_identity_group" {
        type        = string
        description = <<-END
          The name of the RBAC security identity group for use with Google
          security groups in Kubernetes RBAC. Group name must be in format
          `gke-security-groups@yourdomain.com`.
        END
      }

      variable "min_master_version" {
        required    = true
        type        = string
        description = <<-END
          The Kubernetes minimal version of the masters. If set to `latest` it
          will pull latest available version in the selected region.
        END
      }

      variable "cluster_secondary_range_name" {
        required    = true
        type        = string
        description = <<-END
          The name of the secondary subnet ip range to use for pods.
        END
      }

      variable "services_secondary_range_name" {
        required    = true
        type        = string
        description = <<-END
          The name of the secondary subnet range to use for services.
        END
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
          A set of zones used for node locations.
        END
      }

      variable "master_authorized_networks_cidr_blocks" {
        type        = list(master_authorized_networks_cidr_block)
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

      variable "vertical_pod_autoscaling_enabled" {
        type        = bool
        default     = false
        description = <<-END
          Vertical Pod Autoscaling automatically adjusts the resources of pods
          controlled by it.
        END
      }

      variable "addon_horizontal_pod_autoscaling" {
        type        = bool
        default     = true
        description = <<-END
          Enable horizontal pod autoscaling addon.
        END
      }

      variable "addon_http_load_balancing" {
        type        = bool
        default     = true
        description = <<-END
          Enable httpload balancer addon.
        END
      }

      variable "addon_network_policy_config" {
        type        = bool
        default     = false
        description = <<-END
          Enable network policy addon.
        END
      }

      variable "network_policy" {
        type        = object(network_policy)
        description = <<-END
          Configuration options for the NetworkPolicy feature.
        END

        attribute "provider" {
          required    = true
          type        = string
          description = <<-END
            Whether network policy is enabled on the cluster.
          END
        }

        attribute "enabled" {
          type        = bool
          default     = "PROVIDER_UNSPECIFIED"
          description = <<-END
            The selected network policy provider.
          END
        }
      }

      variable "maintenance_start_time" {
        type        = string
        default     = "00:00"
        description = <<-END
          Time window specified for daily or recurring maintenance operations in
          RFC3339 format. Default is midnight UTC.
        END
      }

      variable "resource_usage_export_bigquery_dataset_id" {
        type        = string
        description = <<-END
          The ID of a BigQuery Dataset for using BigQuery as the destination of
          resource usage export.
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
        default     = {}
        description = <<-END
          Cluster autoscaling configuration. For more info see 
          [documentation](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling)
        END

        attribute "enable" {
          required    = true
          type        = bool
          description = <<-END
            Whether node auto-provisioning is enabled. Resource limits for cpu
            and memory must be defined to enable node auto-provisioning.
          END
        }

        attribute "resource_limits" {
          type        = list(resource_limit)
          description = <<-END
            Global constraints for machine resources in the cluster. Configuring
            the `cpu` and `memory` types is required if node auto-provisioning
            is enabled. These limits will apply to node pool autoscaling in
            addition to node auto-provisioning.
          END

          attribute "resource_type" {
            required    = true
            type        = string
            description = <<-END
              The type of the resource. For example, `cpu` and `memory`. See the
              [guide to using Node Auto-Provisioning].(https://cloud.google.com/kubernetes-engine/docs/how-to/node-auto-provisioning)
              for a list of types.
            END
          }

          attribute "maximum" {
            type        = number
            description = <<-END
              Maximum amount of the resource in the cluster.
            END
          }

          attribute "minimum" {
            type        = number
            description = <<-END
              Minimum amount of the resource in the cluster.
            END
          }
        }

        attribute "auto_provisioning_defaults" {
          type        = list(auto_provisioning_default)
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
              roles to that service account for only the resources that it
              needs.
            END
          }

          attribute "service_account" {
            type        = string
            description = <<-END
              The Google Cloud Platform Service Account to be used by the
              node VMs.
            END
          }
        }
      }

      variable "logging_service" {
        type        = string
        default     = "logging.googleapis.com/kubernetes"
        description = <<-END
          The logging service that the cluster should write logs to. Available
          options include `logging.googleapis.com`, and `none`.
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

      variable "enable_private_endpoint" {
        type        = bool
        default     = false
        description = <<-END
          Whether nodes have internal IP addresses only.
        END
      }

      variable "master_ipv4_cidr_block" {
        required    = true
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
        default     = false
        description = <<-END
          Enable Shielded Nodes features on all nodes in this cluster.
        END
      }

      variable "enable_binary_authorization" {
        type        = bool
        default     = false
        description = <<-END
          Enable BinAuthZ Admission controller.
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
            null_resource = {
              create = "4m"
              update = "4m"
              delete = "4m"
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
