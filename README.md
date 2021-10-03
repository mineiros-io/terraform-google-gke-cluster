[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![Terraform Version][badge-terraform]][releases-terraform]
[![Google Provider Version][badge-tf-gcp]][releases-google-provider]
[![Join Slack][badge-slack]][slack]

# terraform-google-gke-cluster

A [Terraform] module for [Google Cloud Platform (GCP)][gcp].

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 3._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.

- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Top-level Arguments](#top-level-arguments)
    - [Module Configuration](#module-configuration)
    - [Main Resource Configuration](#main-resource-configuration)
    - [Extended Resource Configuration](#extended-resource-configuration)
- [Module Attributes Reference](#module-attributes-reference)
- [External Documentation](#external-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

In contrast to the plain `terraform_google_container_cluster` resource this module has better features.
While all security features can be disabled as needed best practices
are pre-configured.

<!--
These are some of our custom features:

- **Default Security Settings**:
  secure by default by setting security to `true`, additional security can be added by setting some feature to `enabled`

- **Standard Module Features**:
  Cool Feature of the main resource, tags

- **Extended Module Features**:
  Awesome Extended Feature of an additional related resource,
  and another Cool Feature

- **Additional Features**:
  a Cool Feature that is not actually a resource but a cool set up from us

- _Features not yet implemented_:
  Standard Features missing,
  Extended Features planned,
  Additional Features planned
-->

## Getting Started

Most basic usage just setting required arguments:

```hcl
module "terraform-google-gke-cluster" {
  source = "github.com/mineiros-io/terraform-google-gke-cluster.git?ref=v0.1.0"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Top-level Arguments

#### Module Configuration

- **`module_enabled`**: _(Optional `bool`)_

  Specifies whether resources in the module will be created.
  Default is `true`.

- **`module_depends_on`**: _(Optional `list(dependencies)`)_

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

  Example:
  ```hcl
  module_depends_on = [
    google_network.network
  ]
  ```

#### Main Resource Configuration

- **`project`**: **_(Required `string`)_**

  The ID of the project in which the resource belongs.

- **`location`**: **_(Required `string`)_**

  The location (region or zone) in which the cluster master will be created.

- **`network`**: **_(Required `string`)_**

  The name or self_link of the Google Compute Engine network to which the cluster is connected. For Shared VPC, set this to the self link of the shared network.

- **`subnetwork`**: **_(Required `string`)_**

  The name or self_link of the Google Compute Engine subnetwork in which the cluster's instances are launched.

- **`name`**: **_(Required `string`)_**

  The name of the cluster.

- **`min_master_version`**: **_(Required `string`)_**

  The Kubernetes minimal version of the masters. If set to 'latest' it will pull latest available version in the selected region.

- **`cluster_secondary_range_name`**: **_(Required `string`)_**

  The name of the secondary subnet ip range to use for pods.

- **`services_secondary_range_name`**: **_(Required `string`)_**

  The name of the secondary subnet range to use for services.

- **`description`**: _(Optional `string`)_

  The description of the cluster.
  Default is `""`.

- **`node_location`**: _(Optional `set(string)`)_

  A set of zones used for node locations.
  Default is `[]`.

- **`master_authorized_networks_cidr_blocks`**: _(Optional `any`)_

  Set of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists).
  Default is `[]`.

  Each `master_authorized_networks_cidr_blocks` object can have the following fields:

  - **`cidr_blocks`**: _(Optional `any`)_

    External networks that can access the Kubernetes cluster master through HTTPS.
    Default is `null`.

    Each `cidr_blocks` object can have the following fields:

    - **`cidr_block`**: _(Optional `string`)_

      External network that can access Kubernetes master through HTTPS. Must be specified in CIDR notation.

    - **`display_name`**: _(Optional `string`)_

      Field for users to identify CIDR blocks.
      Default is `null`.

- **`vertical_pod_autoscaling_enabled`**: _(Optional `bool`)

  Vertical Pod Autoscaling automatically adjusts the resources of pods controlled by it.
  Default is `false`.

- **`addon_horizontal_pod_autoscaling`**: _(Optional `bool`)

  Enable horizontal pod autoscaling addon.
  Default is `true`.

- **`addon_http_load_balancing`**: _(Optional `bool`)_

  Enable httpload balancer addon.
  Default is `true`

- **`addon_network_policy_config`**: _(Optional `bool`)_

  Enable network policy addon.
  Default is `false`

- **`network_policy`**: _(Optional `any`)_

  Configuration options for the NetworkPolicy feature.
  Default is `null`.

  Each `network_policy` object can have the following fields:

  - **`enabled`**: **_(Required `bool`)_**

    Whether network policy is enabled on the cluster.

  - **`provider`**: _(Optional `string`)_

    The selected network policy provider.
    Default is `PROVIDER_UNSPECIFIED`.


- **`maintenance_start_time`**: _(Optional `string`)_

  Time window specified for daily or recurring maintenance operations in RFC3339 format.
  Default is `00:00`.

- **`resource_usage_export_bigquery_dataset_id`**: _(Optional `string`)_

  The ID of a BigQuery Dataset for using BigQuery as the destination of resource usage export.
  Default is `null`.

- **`enable_network_egress_metering`**: _(Optional `bool`)_

  Whether to enable network egress metering for this cluster. If enabled, a daemonset will be created in the cluster to meter network egress traffic.
  Default is `false`.

- **`enable_resource_consumption_metering`**: _(Optional `bool`)_

  Whether to enable resource consumption metering on this cluster. When enabled, a table will be created in the resource export BigQuery dataset to store resource consumption data. The resulting table can be joined with the resource usage table or with BigQuery billing export.
  Default is `true`.

- **`cluster_autoscaling`**: _(Optional `any`)_

  Cluster autoscaling configuration. See [more details](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling).
  Default is `{}`.

  A `cluster_autoscaling` object can have the following fields:

  - **`enabled`**: **_(Required `string`)_**

    Whether node auto-provisioning is enabled. Resource limits for cpu and memory must be defined to enable node auto-provisioning.

  - **`resource_limits`**: _(Optional `any`)_

    Global constraints for machine resources in the cluster. Configuring the cpu and memory types is required if node auto-provisioning is enabled. These limits will apply to node pool autoscaling in addition to node auto-provisioning. Structure is documented below.

    Each `resource_limits` object can have the following fields:

    - **`resource_type`**: **_(Required `string`)_**

      The type of the resource. For example, `cpu` and `memory`. See the guide to using Node Auto-Provisioning for a list of types.

    - **`minimum`**: _(Optional `number`)_

      Minimum amount of the resource in the cluster.

    - **`maximum`**: _(Optional `number`)_

      Maximum amount of the resource in the cluster.

  <!-- - **`auto_provisioning_defaults`**: _(Optional `any`)_

    Contains defaults for a node pool created by NAP. Structure is documented below.

    Each `auto_provisioning_defaults` object can have the following fields:

    - **`min_cpu_platform`**: _(Optional, Beta `string`)_

      Minimum CPU platform to be used for NAP created node pools. The instance may be scheduled on the specified or newer CPU platform. Applicable values are the friendly names of CPU platforms, such as `"Intel Haswell"` or `"Intel Sandy Bridge"`.

    - **`oauth_scopes`**: _(Optional `string`)_

      Scopes that are used by NAP when creating node pools. Use the `"https://www.googleapis.com/auth/cloud-platform"` scope to grant access to all APIs. It is recommended that you set `service_account` to a non-default service account and grant IAM roles to that service account for only the resources that it needs. -->

- **`logging_service`**: _(Optional `string`)_

  The logging service that the cluster should write logs to. Available options include `logging.googleapis.com, logging.googleapis.com/kubernetes` (beta), and none.
  Default is `"logging.googleapis.com/kubernetes"`.

- **`monitoring_service`**: _(Optional `string`)_

  The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.`googleapis.com`, `monitoring.googleapis.com/kubernetes` (beta) and none.
  Default is `"monitoring.googleapis.com/kubernetes"`.

- **`resource_labels`**: _(Optional `map(string)`)_

  The GCE resource labels (a map of key/value pairs) to be applied to the cluster
  Default is `{}`.

- **`default_max_pods_per_node`**: _(Optional `number`)_

  The maximum number of pods to schedule per node.
  Default is `110`.

- **`default_max_pods_per_node`**: _(Optional `number`)_

  The maximum number of pods to schedule per node.
  Default is `110`.

- **`enable_private_endpoint`**: _(Optional `bool`)_

  Whether nodes have internal IP addresses only.
  Default is `true`.

- **`master_ipv4_cidr_block`**: **_(Required `string`)_**

  The IP range in CIDR notation to use for the hosted master network.

- **`database_encryption_key_name`**: _(Optional `bool`)_

  The name of a CloudKMS key to enable application-layer secrets encryption settings. If non-null the state will be set to: ENCRYPTED else DECRYPTED."
  Default is `null`.

- **`"database_encryption_key_name"`**: _(Optional `bool`)_

  The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `UNSPECIFIED`."
  Default is `null`.

- **`enable_shielded_nodes`**: _(Optional `bool`)_

  Enable Shielded Nodes features on all nodes in this cluster.
  Default is `true`.

- **`enable_binary_authorization`**: _(Optional `bool`)_

  Enable BinAuthZ Admission controller.
  Default is `false`.

#### Extended Resource Configuration

## Module Attributes Reference

The following attributes are exported in the outputs of the module:

- **`module_enabled`**

  Whether this module is enabled.

## External Documentation

- Google Documentation:
  - Google Kubernetes Engine: https://cloud.google.com/kubernetes-engine/docs

- Terraform Google Provider Documentation:
  - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster

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

Copyright &copy; 2020-2021 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-gke-cluster
[hello@mineiros.io]: mailto:hello@mineiros.io

<!-- markdown-link-check-disable -->

[badge-build]: https://github.com/mineiros-io/terraform-google-gke-cluster/workflows/Tests/badge.svg

<!-- markdown-link-check-enable -->

[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-google-gke-cluster.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack

<!-- markdown-link-check-disable -->

[build-status]: https://github.com/mineiros-io/terraform-google-gke-cluster/actions
[releases-github]: https://github.com/mineiros-io/terraform-google-gke-cluster/releases

<!-- markdown-link-check-enable -->

[releases-terraform]: https://github.com/hashicorp/terraform/releases
[badge-tf-gcp]: https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform
[releases-google-provider]: https://github.com/terraform-providers/terraform-provider-google/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[gcp]: https://cloud.google.com/
[semantic versioning (semver)]: https://semver.org/

<!-- markdown-link-check-disable -->

[variables.tf]: https://github.com/mineiros-io/terraform-google-gke-cluster/blob//main/variables.tf
<!-- [examples/]: https://github.com/mineiros-io/terraform-google-gke-cluster/blob//main/examples -->
[issues]: https://github.com/mineiros-io/terraform-google-gke-cluster/issues
[license]: https://github.com/mineiros-io/terraform-google-gke-cluster/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-gke-cluster/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-gke-cluster/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-gke-cluster/blob/main/CONTRIBUTING.md

<!-- markdown-link-check-enable -->
