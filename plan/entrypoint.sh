#!/bin/sh
set -e

cd "${TF_ACTION_WORKING_DIR:-.}"

WORKSPACE=${TF_ACTION_WORKSPACE:-default}
terraform workspace select "$WORKSPACE"

set +e
OUTPUT=$(sh -c "TF_IN_AUTOMATION=true terraform plan -no-color -input=false $*" 2>&1)
SUCCESS=$?
echo "$OUTPUT"
set -e

if [ "$TF_ACTION_COMMENT" = "1" ] || [ "$TF_ACTION_COMMENT" = "false" ]; then
    exit $SUCCESS
fi

# Remove "Refreshing Terraform state" details.
OUTPUT=$(echo "$OUTPUT" | sed -n -r '/-{72}/,/-{72}/{ /-{72}/d; p }')

# Reduce to summary if output line count is greater than 20.
if [ $(echo "$OUTPUT" | wc -l) -gt 20 ]; then
    OUTPUT="
<details><summary>Show Output</summary>

\`\`\`diff
$OUTPUT
\`\`\`

</details>
"
else
    OUTPUT="
\`\`\`diff
$OUTPUT
\`\`\`
"
fi

COMMENT=""

# If not successful, post failed plan output.
if [ $SUCCESS -ne 0 ]; then
    COMMENT="#### \`terraform plan\` Failed
$OUTPUT"
else
    FMT_PLAN=$(echo "$OUTPUT" | sed -r -e 's/^  \+/\+/g' | sed -r -e 's/^  ~/~/g' | sed -r -e 's/^  -/-/g')
    COMMENT="#### \`terraform plan\` Success
$FMT_PLAN"
fi

PAYLOAD=$(echo '{}' | jq --arg body "$COMMENT" '.body = $body')
COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMENTS_URL" > /dev/null

exit $SUCCESS
