# Changelog

## v0.8.0

### Added

* Added an `import` subcommand. ([#117](https://github.com/hashicorp/terraform-github-actions/pull/117))
* Added a `taint` subcommand. ([#134](https://github.com/hashicorp/terraform-github-actions/pull/134))

### Changed

* Use unary operator to test for non-empty variable. ([#145](https://github.com/hashicorp/terraform-github-actions/pull/145))

## v0.7.1

### Fixed

* Fixed missing `tf_actions_plan_has_changes` output when `plan` exit code is `0`. ([#136](https://github.com/hashicorp/terraform-github-actions/pull/136))

## v0.7.0

### Added

* Added `tf_actions_plan_output` output. ([#119](https://github.com/hashicorp/terraform-github-actions/pull/119))

### Changed

* Removed unecessary step in `Dockerfile`. ([#132](https://github.com/hashicorp/terraform-github-actions/pull/132))

### Fixed

* Process multi-line outputs correctly. ([#116](https://github.com/hashicorp/terraform-github-actions/pull/116))
* Fixed typo in outputs documentation. ([#126](https://github.com/hashicorp/terraform-github-actions/pull/126))

## v0.6.4

### Added

* Added the ability to download latest stable Terraform version when `tf_actions_version` is set to `latest`.

## v0.6.3

### Added

* Added the ability to configure a CLI credentials file to authenticate to Terraform Cloud/Enterprise.

## v0.6.2

### Added

* Added an `output` subcommand and corresponding `tf_actions_output` output.

### Fixed

* Fixed improper passing of arguments to the subcommand. ([#114](https://github.com/hashicorp/terraform-github-actions/issues/114))

## v0.6.1

### Fixed

* Fixed improper handling of `args` in each `terraform` command when `args` contained no value. ([#109](https://github.com/hashicorp/terraform-github-actions/issues/109)) ([#110](https://github.com/hashicorp/terraform-github-actions/issues/110))

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
