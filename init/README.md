# Terraform Init Action
Runs `terraform init` to initialize a Terraform working directory. This action will comment back on the pull request on failure.

## Success Criteria
This action succeeds if `terraform init` runs without error.

## Usage
To use the `init` action, add it to your workflow file.

```workflow
action "terraform init" {
  # Replace <latest tag> with the latest tag from https://github.com/hashicorp/terraform-github-actions/releases.
  uses = "hashicorp/terraform-github-actions/init@<latest tag>"
  
  # See Environment Variables below for details.
  env = {
    TF_ACTION_WORKING_DIR = "."
  }
  
  # We need the GitHub token to be able to comment back on the pull request.
  secrets = ["GITHUB_TOKEN"]
}
```

## Environment Variables
| Name                    | Default   | Description                                                                      |
|-------------------------|-----------|----------------------------------------------------------------------------------|
| `TF_ACTION_WORKING_DIR` | `"."`     | Which directory `init` runs in. Relative to the root of the repo.            |
| `TF_ACTION_COMMENT`     | `"true"`  | Set to `"false"` to disable commenting back on pull on error. |


## Secrets
The `GITHUB_TOKEN` secret is required for posting a comment back to the pull request if `init` fails.

If you have set `TF_ACTION_COMMENT = "false"`, then `GITHUB_TOKEN` is not required.

## Arguments
Arguments to `init` will be appended to the `terraform init` command:

```workflow
action "terraform init" {
  ...
  args = ["-lock=false"]
}
```
