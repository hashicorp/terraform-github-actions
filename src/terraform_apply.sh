#!/bin/bash

function terraformApply {
  # Gather the output of `terraform apply`.
  echo "apply: info: applying Terraform configuration in ${tfWorkingDir}"
  applyOutput=$(terraform apply -auto-approve -input=false 2>&1)
  applyExitCode=${?}

  # Exit code of 0 indicates success. Print the output and exit.
  if [ ${applyExitCode} -eq 0 ]; then
    echo "apply: info: successfully applied Terraform configuration in ${tfWorkingDir}"
    echo "${applyOutput}"
    echo
    exit ${applyExitCode}
  fi

  # Exit code of !0 indicates failure.
  echo "apply: error: failed to apply Terraform configuration in ${tfWorkingDir}"
  echo "${applyOutput}"
  echo

  # Comment on the pull request if necessary.
  if [ "$GITHUB_EVENT_NAME" == "pull_request" ] && [ "${tfComment}" == "1" ]; then
    applyCommentWrapper="#### \`terraform apply\` Failed
<details><summary>Show Output</summary>

\`\`\`
${applyOutput}
\`\`\`

</details>

*Workflow: \`${GITHUB_WORKFLOW}\`, Action: \`${GITHUB_ACTION}\`, Working Directory: \`${tfWorkingDir}\`*"

    applyCommentWrapper=$(stripColors "${applyCommentWrapper}")
    echo "apply: info: creating JSON"
    applyPayload=$(echo '{}' | jq --arg body "${applyCommentWrapper}" '.body = $body')
    applyCommentsURL=$(cat ${GITHUB_EVENT_PATH} | jq -r .pull_request.comments_url)
    echo "apply: info: commenting on the pull request"
    curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" --header "Content-Type: application/json" --data "${applyPayload}" "${applyCommentsURL}" > /dev/null
  fi

  exit ${applyExitCode}
}
