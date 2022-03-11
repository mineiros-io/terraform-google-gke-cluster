# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[unreleased]: https://github.com/mineiros-io/terraform-google-gke-cluster/compare/v0.0.2...HEAD
[0.0.2]: https://github.com/mineiros-io/terraform-google-gke-cluster/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/mineiros-io/terraform-google-gke-cluster/releases/tag/v0.0.1
