# Changelog

## v0.6.0

### Added

* Allow passing arguments using GitHub Actions `args` attribute. ([#105](https://github.com/hashicorp/terraform-github-actions/issues/105))

### Changed

* Updated examples to reflect new additions.

## v0.5.4

### Changed

* Always post a comment on a pull request regardless of exit code when using `apply`. ([#97](https://github.com/hashicorp/terraform-github-actions/issues/97))
* Pass comment content to `jq` using pipes instead of arguments.

## v0.5.3

### Fixed

* Fixed improper comment formatting on `fmt`, `plan`, and `apply`.

## v0.5.2

### Fixed

* Fixed an error with `terraform fmt` processing STDERR output when `TF_LOG` was set.

## v0.5.1

### Fixed

* Do not use `-recursive` option with `terraform fmt` for Terraform 0.11.x. ([#90](https://github.com/hashicorp/terraform-github-actions/issues/90))

## v0.5.0

### Added

* Added new YAML syntax for GitHub Actions. 

### Changed

* Completely refactored the codebase into one GitHub Action. Please refer to the README for current usage.

### Removed

* Removed all `TF_ACTION` environment variables. Please refer to the README for current usage.
* Removed HashiCorp Configuration Language (HCL) syntax.

### Fixed

* The actions now use the new YAML syntax. ([#67](https://github.com/hashicorp/terraform-github-actions/issues/67))
* Added support for Terraform 0.11.14. ([#42](https://github.com/hashicorp/terraform-github-actions/issues/67))
* Comments will not be posted to pull requests when `terraform plan` contains no changes. ([#29](https://github.com/hashicorp/terraform-github-actions/issues/67))
* Added ability to specify a Terraform version to use. ([#23](https://github.com/hashicorp/terraform-github-actions/issues/67))
