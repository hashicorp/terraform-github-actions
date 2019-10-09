FROM hashicorp/terraform:0.12.10

LABEL "com.github.actions.name"="terraform fmt"
LABEL "com.github.actions.description"="Validate terraform files are formatted"
LABEL "com.github.actions.icon"="terminal"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="https://github.com/hashicorp/terraform-github-actions"
LABEL "homepage"="http://github.com/hashicorp/terraform-github-actions"
LABEL "maintainer"="HashiCorp Terraform Team <terraform@hashicorp.com>"

RUN apk --update --no-cache add jq curl bash

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
