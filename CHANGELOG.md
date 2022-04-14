# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.6]

### Added

-  Add missing variables to README.md

## [0.0.5]

### Added

- Added more comprehensive docs in README.md

### Removed

- Removed `cluster_autoscaling` as it only applies to a clusters default node pool which are not supported by this module.

## [0.0.4]

### Added

- Add support for `gcp_filestore_csi_driver_config` block

### Changed

- Turn `var.location` to be optional
- Change `var.network` and `var.subnetwork` to be optional variables
- Change minimum required version of google provider to `v4.10.0`

### Fixed

- Fix types and validation for `var.logging_enable_components` and `var.monitoring_enable_components`
- Fix `for_each` statement in `master_authorized_networks_config` block

### Removed

- Remove support for the `cloudrun_config` block as it is no longer available as a GKE add-on
- Remove support confidential nodes since it is a beta feature

## [0.0.3]

### Added

- Add all missing attributes available in google provider `v4.1`
- Add variable validation for `networking_mode`, `logging_enable_components`, `logging_service`, `monitoring_enable_components` and `release_channel`.
- Add unit-tests
- Add default values for `enable_intranode_visibility` and `private_ipv6_google_access`

### Changed

- Rename `maintenance_exclusion` attribute to `maintenance_exclusions` in `recurring_window` maintenance policy
- Update README and add missing variables
- Disable the `network_policy` block per default
- Rename `var.enabled_vertical_pod_autoscaling` to `var.enable_vertical_pod_autoscaling`

### Fixed

- Wrap `name` output in `try` to ensure integrity when `module_enabled = false`

## [0.0.2]

### Added

- BREAKING CHANGE: Set minimum required provider version to `v4.1`
- Add module configuration variables
- Add support for the `authenticator_groups_config` block

### Changed

- BREAKING CHANGE: Remove support for `google_project_service` resource
  Please remove service resource from state
- BREAKING CHANGE: Removed `master_auth` block
- Refactored `workload_pool` block

## [0.0.1]

### Added

- Initial Implementation

[unreleased]: https://github.com/mineiros-io/terraform-google-gke-cluster/compare/v0.0.6...HEAD
[0.0.6]: https://github.com/mineiros-io/terraform-google-gke-cluster/compare/v0.0.5...v0.0.6
[0.0.5]: https://github.com/mineiros-io/terraform-google-gke-cluster/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/mineiros-io/terraform-google-gke-cluster/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/mineiros-io/terraform-google-gke-cluster/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/mineiros-io/terraform-google-gke-cluster/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/mineiros-io/terraform-google-gke-cluster/releases/tag/v0.0.1
