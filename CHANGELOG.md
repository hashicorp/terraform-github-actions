# Changelog

## v0.5.0

### Added

* Added new YAML syntax for GitHub Actions. 

### Changed

* Completely refactored the codebase into one GitHub Action. Please refer to the README for current usage.

### Deprecated

N/A

### Removed

* Removed all `TF_ACTION` environment variables. Please refer to the README for current usage.
* Removed HashiCorp Configuration Language (HCL) syntax.

### Fixed

* The actions now use the new YAML syntax. ([#67](https://github.com/hashicorp/terraform-github-actions/issues/67))
* Added support for Terraform 0.11.14. ([#42](https://github.com/hashicorp/terraform-github-actions/issues/67))
* Comments will not be posted to pull requests when `terraform plan` contains no changes. ([#29](https://github.com/hashicorp/terraform-github-actions/issues/67))
* Added ability to specify a Terraform version to use. ([#23](https://github.com/hashicorp/terraform-github-actions/issues/67))

### Security

N/A
