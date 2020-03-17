# Comments in Non-Pull Request Workflows

If you want to post comments to a PR/issue from a Github Actions workflow, there are two ways to do so:

1. Run your workflow with `on: pull_request`, and this action will automatically detect the correct comments API URL
2. Run this action with `tf_actions_comment_url` input defined.

Here's an example of using #2 to apply code in a PR based on PR comments.

**Note** There is no access control for this action -- anyone with access to comment on your repository can trigger the `terraform apply` action.

```yaml
name: PR comment deploy

on:
  issue_comment:
    types:
      - created

jobs:
  deploy:
    # Only run for
    # 1. Comments starting with "apply "
    # 2. In a pull request (startsWith fails if the key doesn't exist)
    if: >
      startsWith(github.event.comment.body, 'apply ')
      && startsWith(github.event.issue.pull_request.url, 'https://')
    name: ${{ github.event.comment.body }}
    runs-on: ubuntu-latest
    steps:
      - name: Load PR details
        id: pr
        run: |
          set -eu

          resp=$(curl -sSf \
            --url ${{ github.event.issue.pull_request.url }} \
            --header 'authorization: Bearer ${{ secrets.GITHUB_TOKEN }}' \
            --header 'content-type: application/json')

          sha=$(jq -r '.head.sha' <<< "$resp")
          echo "::set-output name=head_sha::$sha"

          comments_url=$(jq -r '.comments_url' <<< "$resp")
          echo "::set-output name=comments_url::$comments_url"
      - name: Checkout
        uses: actions/checkout@v2.0.0
        with:
          # By default (in a non-pull request build) you get HEAD of 'master'
          ref: ${{ steps.pr.outputs.head_sha }}
      - name: Terraform Init
        uses: hashicorp/terraform-github-actions@master
        with:
          tf_actions_version: latest
          tf_actions_subcommand: init
      - name: Terraform Apply
        uses: hashicorp/terraform-github-actions@master
        with:
          tf_actions_version: latest
          tf_actions_subcommand: apply
          tf_actions_comment: true # default, but being explicit
          tf_actions_comment_url: ${{ steps.pr.outputs.comments_url }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
