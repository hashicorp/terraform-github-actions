#!/bin/sh
set -e
cd "${TF_ACTION_WORKING_DIR:-.}"

if [[ ! -z "$TF_ACTION_WORKSPACE" ]] && [[ "$TF_ACTION_WORKSPACE" != "default" ]]; then
  terraform workspace select "$TF_ACTION_WORKSPACE"
fi

set +e
OUTPUT=$(sh -c "terraform validate -no-color $*" 2>&1)
SUCCESS=$?
echo "$OUTPUT"
set -e

if [ $SUCCESS -eq 0 ]; then
    exit 0
fi

if [ "$TF_ACTION_COMMENT" = "1" ] || [ "$TF_ACTION_COMMENT" = "false" ]; then
    exit $SUCCESS
fi

COMMENT="#### \`terraform validate\` Failed
\`\`\`
$OUTPUT
\`\`\`
*Workflow: \`$GITHUB_WORKFLOW\`, Action: \`$GITHUB_ACTION\`*"
PAYLOAD=$(echo '{}' | jq --arg body "$COMMENT" '.body = $body')
COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
if [ "$COMMENTS_URL" != 'null' ] ; then curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMENTS_URL" > /dev/null ; fi

exit $SUCCESS
