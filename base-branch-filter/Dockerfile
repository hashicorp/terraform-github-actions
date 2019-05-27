FROM alpine:latest

LABEL "com.github.actions.name"="base branch filter"
LABEL "com.github.actions.description"="Filters pull request events based on their base branch."
LABEL "com.github.actions.icon"="filter"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="https://github.com/hashicorp/terraform-github-actions"
LABEL "homepage"="http://github.com/hashicorp/terraform-github-actions"
LABEL "maintainer"="HashiCorp Terraform Team <terraform@hashicorp.com>"

RUN apk --no-cache add jq

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
