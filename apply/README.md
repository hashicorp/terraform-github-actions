# Terraform Apply Action
Runs `terraform apply`.

If run via the `pull_request` event, will comment back on the pull request with the output.

If run via the `push` event, this action won't comment back on the pull request but its output can be viewed from the Actions tab in the main repo view.

See [Running Apply](https://www.terraform.io/docs/github-actions/running-apply.html) for more details.

## Success Criteria
This action succeeds if terraform apply runs without error.

## Usage
To use the `apply` action, add it to your workflow file.

NOTE: See [Running Apply](https://www.terraform.io/docs/github-actions/running-apply.html) for a full example of how to use the `apply` action properly.

```yaml
on: pull_request
name: Terraform Apply
jobs:
  apply:
    runs-on: ubuntu-latest
    steps:
    
    - name: terraform-init
      uses: hashicorp/terraform-github-actions/init@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        TF_ACTION_WORKING_DIR: .

    - name: terraform-apply
      uses: hashicorp/terraform-github-actions/apply@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        TF_ACTION_WORKING_DIR: .
        TF_ACTION_WORKSPACE: default 

```

## Environment Variables
Name | Default | Description
--- | --- | ---
`TF_ACTION_WORKING_DIR` | `"."` | Which directory `plan` runs in. Relative to the root of the repo.
`TF_ACTION_COMMENT` | `"true"` | Set to `"false"` to disable commenting back on pull request.
`TF_ACTION_WORKSPACE` | `"default"` | Which [Terraform workspace](https://www.terraform.io/docs/state/workspaces.html) to run in.
`TF_ACTION_TFE_HOSTNAME` | `"app.terraform.io"` | If using Terraform Enterprise, set this to its hostname.

## Workspaces
The plan action only supports running in a single [Terraform workspace](https://www.terraform.io/docs/state/workspaces.html) defined by the `TF_ACTION_WORKSPACE` environment variable.

If you need to run `plan` in multiple workspaces, see [Workspaces](https://www.terraform.io/docs/state/workspaces.html).

## Secrets
Name | Description
--- | ---
`GITHUB_TOKEN` | Required for posting comments to the pull request unless `TF_ACTION_COMMENT = "false"`.
`TF_ACTION_TFE_TOKEN` | If using the Terraform Cloud [remote backend](https://www.terraform.io/docs/backends/types/remote.html) set this secret to a [user API token](https://www.terraform.io/docs/cloud/users-teams-organizations/users.html#api-tokens).

You'll also likely need to add secrets for your providers, like `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` or `GOOGLE_CREDENTIALS`.

⚠️ WARNING ⚠️ These secrets could be exposed if the `apply` action is run on a malicious Terraform file. To avoid this, we recommend you do not use this action on public repos or repos where untrusted users can submit pull requests.

## Arguments
Arguments to `apply` will be appended to the `terraform apply` command:

```yaml
- name: terraform-apply
  uses: hashicorp/terraform-github-actions/apply@master
  with:
    args: "-var", "foo=bar", "-var-file=foo"
```
