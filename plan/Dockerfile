FROM hashicorp/terraform:0.12.4

LABEL "com.github.actions.name"="terraform plan"
LABEL "com.github.actions.description"="Run terraform plan"
LABEL "com.github.actions.icon"="book-open"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="https://github.com/hashicorp/terraform-github-actions"
LABEL "homepage"="http://github.com/hashicorp/terraform-github-actions"
LABEL "maintainer"="HashiCorp Terraform Team <terraform@hashicorp.com>"

RUN apk --no-cache add jq curl

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
