#!/bin/sh
set -e

MERGED_AT=$(cat /github/workflow/event.json | jq -r .pull_request.merged_at)
BASE_REF=$(cat /github/workflow/event.json | jq -r .pull_request.base.ref)
DEFAULT_BRANCH=$(cat /github/workflow/event.json | jq -r .pull_request.base.repo.default_branch)
echo "$MERGED_AT"
echo "$BASE_REF"
echo "$DEFAULT_BRANCH"
if [ $MERGED_AT = "null" ] && [ $BASE_REF == $DEFAULT_BRANCH]; then
    exit 0
fi

cd "${TF_ACTION_WORKING_DIR:-.}"

WORKSPACE=${TF_ACTION_WORKSPACE:-default}
terraform workspace select "$WORKSPACE"

set +e
OUTPUT=$(sh -c "TF_IN_AUTOMATION=true terraform apply -auto-approve -no-color -input=false $*" 2>&1)
SUCCESS=$?
echo "$OUTPUT"
set -e

if [ "$TF_ACTION_COMMENT" = "1" ] || [ "$TF_ACTION_COMMENT" = "false" ]; then
    exit $SUCCESS
fi

# Build the comment we'll post to the PR.
COMMENT=""
if [ $SUCCESS -ne 0 ]; then
    COMMENT="#### \`terraform apply\` Failed
$OUTPUT"
else
    # Remove "Refreshing state..." lines by only keeping output after the
    # delimiter (72 dashes) that represents the end of the refresh stage.
    # We do this to keep the comment output smaller.
    if echo "$OUTPUT" | egrep '^-{72}$'; then
        OUTPUT=$(echo "$OUTPUT" | sed -n -r '/-{72}/,/-{72}/{ /-{72}/d; p }')
    fi

    # Remove whitespace at the beginning of the line for added/modified/deleted
    # resources so the diff markdown formatting highlights those lines.
    OUTPUT=$(echo "$OUTPUT" | sed -r -e 's/^  \+/\+/g' | sed -r -e 's/^  ~/~/g' | sed -r -e 's/^  -/-/g')
    COMMENT="#### \`terraform apply\` Success
$OUTPUT"
fi

# Post the comment.
PAYLOAD=$(echo '{}' | jq --arg body "$COMMENT" '.body = $body')
COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
echo $COMMENTS_URL
curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMENTS_URL" > /dev/null

exit $SUCCESS
