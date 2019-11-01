# Terraform GitHub Actions

Terraform GitHub Actions allow you to run Terraform commands within GitHub Actions.

The output of the actions can be viewed from the Actions tab in the main repository view. If the actions are executed on a `pull_request` event, a comment may be posted on the pull request.

## Success Criteria

An exit code of `0` is considered a successful execution.

## Usage

Please refer to the examples within the `examples` directory for usage.

## Inputs

| Name                     | Required | Default | Description                                 |
|--------------------------|----------|---------|---------------------------------------------|
| `tf_actions_version`     | `true`   |         | Terraform version to install.               |
| `tf_actions_subcommand`  | `true`   |         | Terraform subcommand to execute.            |
| `tf_actions_working_dir` | `false`  | `.`     | Terraform working directory.                |
| `tf_actions_comment`     | `false`  | `true`  | Whether or not to comment on pull requests. |

## Outputs

| Name                          | Description                                          |
|-------------------------------|------------------------------------------------------|
| `tf_actions_plan_has_changes` | Whether or not the Terraform plan contained changes. |

## Secrets

| Name                     | Description                                                                                                          |
|--------------------------|----------------------------------------------------------------------------------------------------------------------|
| `GITHUB_TOKEN`           | The GitHub API token used to post comments to pull requests. Not required if `tf_actions_comment` is set to `false`. |

Other secrets may be needed to authenticate with Terraform backends and providers. 

**WARNING:** These secrets could be exposed if the action is executed on a malicious Terraform file. To avoid this, it is recommended to not use this action on public repos or repos where untrusted users can submit pull requests.

## Environment Variables

The usual [Terraform environment variables](https://www.terraform.io/docs/commands/environment-variables.html) are supported. Here are the environments variables that might be the most beneficial.

* [`TF_LOG`](https://www.terraform.io/docs/commands/environment-variables.html#tf_log)
* [`TF_VAR_name`](https://www.terraform.io/docs/commands/environment-variables.html#tf_var_name)
* [`TF_CLI_ARGS`](https://www.terraform.io/docs/commands/environment-variables.html#tf_cli_args-and-tf_cli_args_name)
* [`TF_CLI_ARGS_name`](https://www.terraform.io/docs/commands/environment-variables.html#tf_cli_args-and-tf_cli_args_name)
* `TF_WORKSPACE`

Other environment variables may be configured to pass data into Terraform backends and providers. If the data is sensitive, consider using [secrets](#secrets) instead.
