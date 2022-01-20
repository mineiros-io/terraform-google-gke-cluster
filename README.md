[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-google-gke-cluster)

[![Build Status](https://github.com/mineiros-io/terraform-google-gke-cluster/workflows/Tests/badge.svg)](https://github.com/mineiros-io/terraform-google-gke-cluster/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-google-gke-cluster.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-google-gke-cluster/releases)
[![Terraform Version](https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version](https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-google/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-google-gke-cluster

A [Terraform](https://www.terraform.io) module to create and manage a Google
Kubernetes Engine (GKE) cluster.
    
**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 4._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Main Resource Configuration](#main-resource-configuration)
  - [Module Configuration](#module-configuration)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [AWS Documentation IAM](#aws-documentation-iam)
  - [Terraform GCP Provider Documentation](#terraform-gcp-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

This module implements the following Terraform resources

- `google_container_cluster`

## Getting Started

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

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Main Resource Configuration

- [**`project`**](#var-project): *(**Required** `string`)*<a name="var-project"></a>

  The ID of the project in which the resource belongs.

- [**`location`**](#var-location): *(**Required** `string`)*<a name="var-location"></a>

  The location (region or zone) in which the cluster master will be
  created.

- [**`network`**](#var-network): *(**Required** `string`)*<a name="var-network"></a>

  The name or `self_link` of the Google Compute Engine network to which
  the cluster is connected. For Shared VPC, set this to the self link of
  the shared network.

- [**`subnetwork`**](#var-subnetwork): *(**Required** `string`)*<a name="var-subnetwork"></a>

  The name or self_link of the Google Compute Engine subnetwork in which
  the cluster's instances are launched.

- [**`name`**](#var-name): *(**Required** `string`)*<a name="var-name"></a>

  The name of the cluster.

- [**`rbac_security_identity_group`**](#var-rbac_security_identity_group): *(Optional `string`)*<a name="var-rbac_security_identity_group"></a>

  The name of the RBAC security identity group for use with Google
  security groups in Kubernetes RBAC. Group name must be in format
  `gke-security-groups@yourdomain.com`.

- [**`min_master_version`**](#var-min_master_version): *(**Required** `string`)*<a name="var-min_master_version"></a>

  The Kubernetes minimal version of the masters. If set to 'latest' it
  will pull latest available version in the selected region.

- [**`cluster_secondary_range_name`**](#var-cluster_secondary_range_name): *(**Required** `string`)*<a name="var-cluster_secondary_range_name"></a>

  The name of the secondary subnet ip range to use for pods.

- [**`services_secondary_range_name`**](#var-services_secondary_range_name): *(**Required** `string`)*<a name="var-services_secondary_range_name"></a>

  The name of the secondary subnet range to use for services.

- [**`description`**](#var-description): *(Optional `string`)*<a name="var-description"></a>

  The description of the cluster.

  Default is `""`.

- [**`node_locations`**](#var-node_locations): *(Optional `set(string)`)*<a name="var-node_locations"></a>

  A set of zones used for node locations.

  Default is `[]`.

- [**`master_authorized_networks_cidr_blocks`**](#var-master_authorized_networks_cidr_blocks): *(Optional `list(master_authorized_networks_cidr_block)`)*<a name="var-master_authorized_networks_cidr_blocks"></a>

  Set of master authorized networks. If none are provided, disallow
  external access (except the cluster node IPs, which GKE automatically
  whitelists).

  Default is `[]`.

  Each `master_authorized_networks_cidr_block` object in the list accepts the following attributes:

  - [**`cidr_block`**](#attr-master_authorized_networks_cidr_blocks-cidr_block): *(**Required** `string`)*<a name="attr-master_authorized_networks_cidr_blocks-cidr_block"></a>

    External network that can access Kubernetes master through HTTPS.
    Must be specified in CIDR notation.

  - [**`display_name`**](#attr-master_authorized_networks_cidr_blocks-display_name): *(Optional `string`)*<a name="attr-master_authorized_networks_cidr_blocks-display_name"></a>

    Field for users to identify CIDR blocks.

- [**`vertical_pod_autoscaling_enabled`**](#var-vertical_pod_autoscaling_enabled): *(Optional `bool`)*<a name="var-vertical_pod_autoscaling_enabled"></a>

  Vertical Pod Autoscaling automatically adjusts the resources of pods
  controlled by it.

  Default is `false`.

- [**`addon_horizontal_pod_autoscaling`**](#var-addon_horizontal_pod_autoscaling): *(Optional `bool`)*<a name="var-addon_horizontal_pod_autoscaling"></a>

  Enable horizontal pod autoscaling addon.

  Default is `true`.

- [**`addon_http_load_balancing`**](#var-addon_http_load_balancing): *(Optional `bool`)*<a name="var-addon_http_load_balancing"></a>

  Enable httpload balancer addon.

  Default is `true`.

- [**`addon_network_policy_config`**](#var-addon_network_policy_config): *(Optional `bool`)*<a name="var-addon_network_policy_config"></a>

  Enable network policy addon.

  Default is `false`.

- [**`network_policy`**](#var-network_policy): *(Optional `object(network_policy)`)*<a name="var-network_policy"></a>

  Configuration options for the NetworkPolicy feature.

  The `network_policy` object accepts the following attributes:

  - [**`provider`**](#attr-network_policy-provider): *(**Required** `string`)*<a name="attr-network_policy-provider"></a>

    Whether network policy is enabled on the cluster.

  - [**`enabled`**](#attr-network_policy-enabled): *(Optional `bool`)*<a name="attr-network_policy-enabled"></a>

    The selected network policy provider.

    Default is `"PROVIDER_UNSPECIFIED"`.

- [**`maintenance_start_time`**](#var-maintenance_start_time): *(Optional `string`)*<a name="var-maintenance_start_time"></a>

  Time window specified for daily or recurring maintenance operations in
  RFC3339 format. Default is midnight UTC.

  Default is `"00:00"`.

- [**`resource_usage_export_bigquery_dataset_id`**](#var-resource_usage_export_bigquery_dataset_id): *(Optional `string`)*<a name="var-resource_usage_export_bigquery_dataset_id"></a>

  The ID of a BigQuery Dataset for using BigQuery as the destination of
  resource usage export.

- [**`enable_network_egress_metering`**](#var-enable_network_egress_metering): *(Optional `bool`)*<a name="var-enable_network_egress_metering"></a>

  Whether to enable network egress metering for this cluster. If
  enabled, a daemonset will be created in the cluster to meter network
  egress traffic.

  Default is `false`.

- [**`enable_resource_consumption_metering`**](#var-enable_resource_consumption_metering): *(Optional `bool`)*<a name="var-enable_resource_consumption_metering"></a>

  Whether to enable resource consumption metering on this cluster. When
  enabled, a table will be created in the resource export BigQuery
  dataset to store resource consumption data. The resulting table can be
  joined with the resource usage table or with BigQuery billing export.

  Default is `true`.

- [**`cluster_autoscaling`**](#var-cluster_autoscaling): *(Optional `object(cluster_autoscaling)`)*<a name="var-cluster_autoscaling"></a>

  Cluster autoscaling configuration. See [more details]
  (https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling)

  Default is `{}`.

  The `cluster_autoscaling` object accepts the following attributes:

  - [**`enable`**](#attr-cluster_autoscaling-enable): *(**Required** `bool`)*<a name="attr-cluster_autoscaling-enable"></a>

    Whether node auto-provisioning is enabled. Resource limits for cpu
    and memory must be defined to enable node auto-provisioning.

  - [**`resource_limits`**](#attr-cluster_autoscaling-resource_limits): *(Optional `list(resource_limit)`)*<a name="attr-cluster_autoscaling-resource_limits"></a>

    Global constraints for machine resources in the cluster. Configuring
    the `cpu` and `memory` types is required if node auto-provisioning
    is enabled. These limits will apply to node pool autoscaling in
    addition to node auto-provisioning.

    Each `resource_limit` object in the list accepts the following attributes:

    - [**`resource_type`**](#attr-cluster_autoscaling-resource_limits-resource_type): *(**Required** `string`)*<a name="attr-cluster_autoscaling-resource_limits-resource_type"></a>

      The type of the resource. For example, `cpu` and `memory`. See the
      guide to [using Node Auto-Provisioning]
      (https://cloud.google.com/kubernetes-engine/docs/how-to/node-auto-provisioning)
      for a list of types.

    - [**`maximum`**](#attr-cluster_autoscaling-resource_limits-maximum): *(Optional `number`)*<a name="attr-cluster_autoscaling-resource_limits-maximum"></a>

      Maximum amount of the resource in the cluster.

    - [**`minimum`**](#attr-cluster_autoscaling-resource_limits-minimum): *(Optional `number`)*<a name="attr-cluster_autoscaling-resource_limits-minimum"></a>

      Minimum amount of the resource in the cluster.

  - [**`auto_provisioning_defaults`**](#attr-cluster_autoscaling-auto_provisioning_defaults): *(Optional `list(auto_provisioning_default)`)*<a name="attr-cluster_autoscaling-auto_provisioning_defaults"></a>

    Contains defaults for a node pool created by NAP.

    Each `auto_provisioning_default` object in the list accepts the following attributes:

    - [**`oauth_scopes`**](#attr-cluster_autoscaling-auto_provisioning_defaults-oauth_scopes): *(Optional `list(string)`)*<a name="attr-cluster_autoscaling-auto_provisioning_defaults-oauth_scopes"></a>

      Scopes that are used by NAP when creating node pools. Use the
      "https://www.googleapis.com/auth/cloud-platform" scope to grant
      access to all APIs. It is recommended that you set
      `service_account` to a non-default service account and grant IAM
      roles to that service account for only the resources that it
      needs.

    - [**`service_account`**](#attr-cluster_autoscaling-auto_provisioning_defaults-service_account): *(Optional `string`)*<a name="attr-cluster_autoscaling-auto_provisioning_defaults-service_account"></a>

      The Google Cloud Platform Service Account to be used by the
      node VMs.

- [**`logging_service`**](#var-logging_service): *(Optional `string`)*<a name="var-logging_service"></a>

  The logging service that the cluster should write logs to. Available
  options include `logging.googleapis.com`, and `none`.

  Default is `"logging.googleapis.com/kubernetes"`.

- [**`monitoring_service`**](#var-monitoring_service): *(Optional `string`)*<a name="var-monitoring_service"></a>

  The monitoring service that the cluster should write metrics to.
  Automatically send metrics from pods in the cluster to the Google
  Cloud Monitoring API. VM metrics will be collected by Google Comput
  Engine regardless of this setting Available options include
  `monitoring.googleapis.com`, and none.

  Default is `"monitoring.googleapis.com/kubernetes"`.

- [**`resource_labels`**](#var-resource_labels): *(Optional `map(string)`)*<a name="var-resource_labels"></a>

  The GCE resource labels (a map of key/value pairs) to be applied to
  the cluster.

  Default is `{}`.

- [**`default_max_pods_per_node`**](#var-default_max_pods_per_node): *(Optional `number`)*<a name="var-default_max_pods_per_node"></a>

  The maximum number of pods to schedule per node.

  Default is `110`.

- [**`enable_private_endpoint`**](#var-enable_private_endpoint): *(Optional `bool`)*<a name="var-enable_private_endpoint"></a>

  Whether nodes have internal IP addresses only.

  Default is `false`.

- [**`master_ipv4_cidr_block`**](#var-master_ipv4_cidr_block): *(**Required** `string`)*<a name="var-master_ipv4_cidr_block"></a>

  The IP range in CIDR notation to use for the hosted master network.

- [**`database_encryption_key_name`**](#var-database_encryption_key_name): *(Optional `string`)*<a name="var-database_encryption_key_name"></a>

  The name of a CloudKMS key to enable application-layer secrets
  encryption settings. If non-null the state will be set to:
  `ENCRYPTED` else `DECRYPTED`.

- [**`release_channel`**](#var-release_channel): *(Optional `string`)*<a name="var-release_channel"></a>

  The release channel of this cluster. Accepted values are
  `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`.

  Default is `"UNSPECIFIED"`.

- [**`enable_shielded_nodes`**](#var-enable_shielded_nodes): *(Optional `bool`)*<a name="var-enable_shielded_nodes"></a>

  Enable Shielded Nodes features on all nodes in this cluster.

  Default is `false`.

- [**`enable_binary_authorization`**](#var-enable_binary_authorization): *(Optional `bool`)*<a name="var-enable_binary_authorization"></a>

  Enable BinAuthZ Admission controller.

  Default is `false`.

### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_timeouts`**](#var-module_timeouts): *(Optional `map(timeout)`)*<a name="var-module_timeouts"></a>

  A map of timeout objects that is keyed by Terraform resource name
  defining timeouts for `create`, `update` and `delete` Terraform operations.

  Supported resources are: `null_resource`, ...

  Example:

  ```hcl
  module_timeouts = {
    null_resource = {
      create = "4m"
      update = "4m"
      delete = "4m"
    }
  }
  ```

  Each `timeout` object in the map accepts the following attributes:

  - [**`create`**](#attr-module_timeouts-create): *(Optional `string`)*<a name="attr-module_timeouts-create"></a>

    Timeout for create operations.

  - [**`update`**](#attr-module_timeouts-update): *(Optional `string`)*<a name="attr-module_timeouts-update"></a>

    Timeout for update operations.

  - [**`delete`**](#attr-module_timeouts-delete): *(Optional `string`)*<a name="attr-module_timeouts-delete"></a>

    Timeout for delete operations.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(dependency)`)*<a name="var-module_depends_on"></a>

  A list of dependencies.
  Any object can be _assigned_ to this list to define a hidden external dependency.

  Default is `[]`.

  Example:

  ```hcl
  module_depends_on = [
    null_resource.name
  ]
  ```

## Module Outputs

The following attributes are exported in the outputs of the module:

- [**`name`**](#output-name): *(`string`)*<a name="output-name"></a>

  The name of the cluster.

- [**`cluster`**](#output-cluster): *(`object(cluster)`)*<a name="output-cluster"></a>

  All arguments in `google_container_cluster`.

- [**`module_enabled`**](#output-module_enabled): *(`bool`)*<a name="output-module_enabled"></a>

  Whether this module is enabled.

## External Documentation

### AWS Documentation IAM

- https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-architecture

### Terraform GCP Provider Documentation

- https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#nested_cluster_autoscaling

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-gke-cluster
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[releases-aws-provider]: https://github.com/terraform-providers/terraform-provider-aws/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[aws]: https://aws.amazon.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-google-gke-cluster/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-gke-cluster/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-gke-cluster/issues
[license]: https://github.com/mineiros-io/terraform-google-gke-cluster/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-gke-cluster/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-gke-cluster/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-gke-cluster/blob/main/CONTRIBUTING.md
