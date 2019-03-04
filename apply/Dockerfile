FROM hashicorp/terraform:0.11.11

LABEL "com.github.actions.name"="terraform apply"
LABEL "com.github.actions.description"="Run terraform apply"
LABEL "com.github.actions.icon"="play"
LABEL "com.github.actions.color"="red"

LABEL "repository"="https://github.com/gotyoooo/terraform-github-actions"
LABEL "homepage"="https://github.com/gotyoooo/terraform-github-actions"
LABEL "maintainer"="gotyoooo"

RUN apk --no-cache add jq

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
