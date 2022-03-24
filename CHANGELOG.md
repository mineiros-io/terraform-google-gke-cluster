# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[unreleased]: https://github.com/mineiros-io/terraform-google-gke-cluster/compare/v0.0.3...HEAD
[0.0.3]: https://github.com/mineiros-io/terraform-google-gke-cluster/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/mineiros-io/terraform-google-gke-cluster/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/mineiros-io/terraform-google-gke-cluster/releases/tag/v0.0.1
