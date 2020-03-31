#!/bin/bash

# Comment on the pull request if necessary.
function sendPRComment() {
  local raw_message=$1
  local wrapped_raw_message="#### \`terraform ${GITHUB_ACTION}\` Failed

\`\`\`
${raw_message}
\`\`\`

*Workflow: \`${GITHUB_WORKFLOW}\`, Action: \`${GITHUB_ACTION}\`, Working Directory: \`${tfWorkingDir}\`, Workspace: \`${tfWorkspace}\`*"

  if [ "$GITHUB_EVENT_NAME" != "pull_request" ] || [ "${tfComment}" != "1" ]; then
    return
  fi

  echo "init: info: commenting on the pull request"
  local message=$(stripColors "${wrapped_raw_message}")
  local payload=$(echo "${message}" | jq -R --slurp '{body: .}')
  local commentURL=$(jq -r .pull_request.comments_url "${GITHUB_EVENT_PATH}")
  echo "${payload}" | curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" --header "Content-Type: application/json" --data @- "${commentURL}" >/dev/null
}
