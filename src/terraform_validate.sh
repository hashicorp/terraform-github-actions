#!/bin/bash

function terraformValidate {
  # Gather the output of `terraform validate`.
  echo "validate: info: validating Terraform configuration in ${tfWorkingDir}"
  validateOutput=$(terraform validate ${*} 2>&1)
  validateExitCode=${?}

  # Exit code of 0 indicates success. Print the output and exit.
  if [ ${validateExitCode} -eq 0 ]; then
    echo "validate: info: successfully validated Terraform configuration in ${tfWorkingDir}"
    echo "${validateOutput}"
    echo
    exit ${validateExitCode}
  fi

  # Exit code of !0 indicates failure.
  echo "validate: error: failed to validate Terraform configuration in ${tfWorkingDir}"
  echo "${validateOutput}"
  echo

  # Comment on the pull request if necessary.
  if [ "${tfComment}" == "1" ] && [ -n "${tfCommentUrl}" ]; then
    validateCommentWrapper="#### \`terraform validate\` Failed

\`\`\`
${validateOutput}
\`\`\`

*Workflow: \`${GITHUB_WORKFLOW}\`, Action: \`${GITHUB_ACTION}\`, Working Directory: \`${tfWorkingDir}\`, Workspace: \`${tfWorkspace}\`*"

    validateCommentWrapper=$(stripColors "${validateCommentWrapper}")
    echo "validate: info: creating JSON"
    validatePayload=$(echo "${validateCommentWrapper}" | jq -R --slurp '{body: .}')
    echo "validate: info: commenting on the pull request"
    echo "${validatePayload}" | curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" --header "Content-Type: application/json" --data @- "${tfCommentUrl}" > /dev/null
  fi

  exit ${validateExitCode}
}
