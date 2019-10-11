# Terraform Validate Action
Runs `terraform validate` to validate the Terraform files in a directory. Validation includes a basic check of syntax as well as checking that all variables declared in the configuration are specified in one of the possible ways:

* `-var foo=...`
* `-var-file=foo.vars`
* `TF_VAR_foo` environment variable
* `terraform.tfvars`
* default value

## Success Criteria
This action succeeds if `terraform validate` runs without error.

## Usage
To use the `validate` action, add it to your workflow file.

```yaml
on: pull_request
name: Terraform Validate
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:

    - name: terraform-init
      uses: hashicorp/terraform-github-actions/init@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        TF_ACTION_WORKING_DIR: .

    - name: terraform-validate
      uses: hashicorp/terraform-github-actions/validate@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        TF_ACTION_WORKING_DIR: .
```

## Environment Variables
| Name | Default | Description |
| --- | --- | --- |
`TF_ACTION_WORKING_DIR` | `"."` | Which directory `validate` runs in. Relative to the root of the repo.
`TF_ACTION_COMMENT` | `"true"` | Set to `"false"` to disable commenting back on pull request if `validate` fails.

## Secrets
The `GITHUB_TOKEN` secret is required for posting a comment back to the pull request if `validate` fails.

If you have set `TF_ACTION_COMMENT = "false"`, then `GITHUB_TOKEN` is not required.

## Arguments
Arguments to `validate` will be appended to the `terraform validate` command:

```yaml
- name: terraform-validate
  uses: hashicorp/terraform-github-actions/validate@master
  with:
    args: "-var", "foo=bar", "-var-file=foo"
```
