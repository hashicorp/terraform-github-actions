# Terraform Init Action
Runs `terraform init` to initialize a Terraform working directory. This action will comment back on the pull request on failure.

## Success Criteria
This action succeeds if `terraform init` runs without error.

## Usage
To use the `init` action, add it to your workflow file.

```yaml
on: pull_request
name: Terraform Init
jobs:
  init:
    runs-on: ubuntu-latest
    steps:

    - name: terraform-init
      uses: hashicorp/terraform-github-actions/init@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        TF_ACTION_WORKING_DIR: .
```

## Environment Variables
| Name | Default | Description |
| --- | --- | --- |
`TF_ACTION_WORKING_DIR` | `"." `| Which directory `init` runs in. Relative to the root of the repo.
`TF_ACTION_COMMENT` | `"true"` | Set to `"false"` to disable commenting back on pull on error.
`TF_ACTION_TFE_HOSTNAME` | `"app.terraform.io"` | If using Terraform Enterprise, set this to its hostname.

## Secrets
| Name | Description |
| --- | --- |
`GITHUB_TOKEN` | Required for posting comments to the pull request unless `TF_ACTION_COMMENT = "false"`.
`TF_ACTION_TFE_TOKEN` | If using the Terraform Cloud [remote backend](https://www.terraform.io/docs/backends/types/remote.html) set this secret to a [user API token](https://www.terraform.io/docs/cloud/users-teams-organizations/users.html#api-tokens).

NOTE: You may also need to add secrets for your providers, like `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` or `GOOGLE_CREDENTIALS`, if you're using a Terraform feature that uses them during `init` (such as Remote State).

⚠️ WARNING ⚠️ These secrets could be exposed if the `plan` action is run on a malicious Terraform file. To avoid this, we recommend you do not use this action on public repos or repos where untrusted users can submit pull requests.

## Arguments
Arguments to `init` will be appended to the `terraform init` command:

```yaml
- name: terraform-init
  uses: hashicorp/terraform-github-actions/init@master
  with:
    args: "-lock=false"
```

