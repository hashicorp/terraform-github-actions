#!/bin/bash

function terraformValidate {
  echo "validate: validating Terraform configuration in ${tfWorkingDir}"
  validateOutput=$(terraform validate)
  validateExitCode=${?}
  
  # Exit code of 0 indicates success.
  if [ ${validateExitCode} -eq 0 ]; then
    echo "validate: successfully validated Terraform configuration in ${tfWorkingDir}"
    echo "${validateOutput}"
    echo
    exit ${validateExitCode}
  # Otherwise, print the output and exit.
  else
    echo "validate: failed to validate Terraform configuration in ${tfWorkingDir}"
    echo "${validateOutput}"
    echo
    # Comment on the pull request
    if [ "$GITHUB_EVENT_NAME" == "pull_request" ] && [ "${tfComment}" == "1" ]; then
      validateCommentWrapper="#### \`terraform validate\` Failed
\`\`\`
${validateOutput}
\`\`\`
*Workflow: \`${GITHUB_WORKFLOW}\`, Action: \`${GITHUB_ACTION}\`*"
      echo "validate: info: creating JSON"
      validatePayload=$(echo '{}' | jq --arg body "${validateCommentWrapper}" '.body = $body')
      validateCommentsURL=$(cat ${GITHUB_EVENT_PATH} | jq -r .pull_request.comments_url)
      echo "validate: info: commenting on the pull request"
      curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" --header "Content-Type: application/json" --data "${validatePayload}" "${validateCommentsURL}" > /dev/null
    fi
    exit ${validateExitCode}
  fi
}
