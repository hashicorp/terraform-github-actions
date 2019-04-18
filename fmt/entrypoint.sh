#!/bin/sh
set -e
cd "${TF_ACTION_WORKING_DIR:-.}"

set +e
UNFMT_FILES=$(sh -c "terraform fmt -check=true -write=false $*" 2>&1)
SUCCESS=$?
echo "$UNFMT_FILES"
set -e

if [ $SUCCESS -eq 0 ]; then
    exit 0
fi

if [ "$TF_ACTION_COMMENT" = "1" ] || [ "$TF_ACTION_COMMENT" = "false" ]; then
    exit $SUCCESS
fi

# Iterate through each unformatted file and build up a comment.
FMT_OUTPUT=""
for file in $UNFMT_FILES; do
FILE_DIFF=$(terraform fmt -write=false -diff=true "$file" | sed -n '/@@.*/,//{/@@.*/d;p}')
FMT_OUTPUT="$FMT_OUTPUT
<details><summary><code>$file</code></summary>

\`\`\`diff
$FILE_DIFF
\`\`\`
</details>
"
done

COMMENT="#### \`terraform fmt\` Failed
$FMT_OUTPUT
*Workflow: \`$GITHUB_WORKFLOW\`, Action: \`$GITHUB_ACTION\`*
"
PAYLOAD=$(echo '{}' | jq --arg body "$COMMENT" '.body = $body')
COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMENTS_URL" > /dev/null

exit $SUCCESS

