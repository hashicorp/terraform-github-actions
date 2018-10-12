# Terraform Validate Action
Runs `terraform validate` to validate the terraform files in a directory.
Validation includes a basic check of syntax as well as checking that all variables declared
in the configuration are specified in one of the possible ways:
* `-var foo=...`
* `-var-file=foo.vars`
* `TF_VAR_foo` environment variable
* `terraform.tfvars`
* default value

## Success Criteria
This action succeeds if `terraform validate` runs without error.

## Usage
To use the `validate` action, add it to your workflow file.

```workflow
action "terraform validate" {
  # Replace <latest tag> with the latest tag from https://github.com/hashicorp/terraform-github-actions/releases.
  uses = "hashicorp/terraform-github-actions/validate@<latest tag>"
  
  # `terraform validate` will always fail unless `terraform init` is run first.
  needs = "terraform init"
  
  # See Environment Variables below for details.
  env = {
    TF_ACTION_WORKING_DIR = "."
  }
  
  # If you need to specify additional arguments to terraform validate, add them here.
  # Otherwise, delete this line or leave the array empty.
  args = ["-var", "foo=bar"]
  
  # We need the GitHub token to be able to comment back on the pull request.
  secrets = ["GITHUB_TOKEN"]
}

action "terraform init" {
  uses = "hashicorp/terraform-github-actions/init@<latest tag>"
  secrets = ["GITHUB_TOKEN"]
}
```

## Environment Variables
| Name                    | Default   | Description                                                                      |
|-------------------------|-----------|----------------------------------------------------------------------------------|
| `TF_ACTION_WORKING_DIR` | `"."`     | Which directory `validate` runs in. Relative to the root of the repo.            |
| `TF_ACTION_COMMENT`     | `"true"`  | Set to `"false"` to disable commenting back on pull request if `validate` fails. |


## Secrets
The `GITHUB_TOKEN` secret is required for posting a comment back to the pull request if `validate` fails.

If you have set `TF_ACTION_COMMENT = "false"`, then `GITHUB_TOKEN` is not required.

## Arguments
Arguments to `validate` will be appended to the `terraform validate`
command:
```workflow
action "terraform validate" {
  ...
  args = ["-var", "foo=bar", "-var-file=foo"]
}
```
