#!/bin/bash

function terraformPlan {
  # Gather the output of `terraform plan`.
  echo "plan: info: planning Terraform configuration in ${tfWorkingDir}"
  planOutput=$(terraform plan -detailed-exitcode -input=false ${*} 2>&1)
  planExitCode=${?}
  planHasChanges=false
  planCommentStatus="Failed"

  # Exit code of 0 indicates success with no changes. Print the output and exit.
  if [ ${planExitCode} -eq 0 ]; then
    echo "plan: info: successfully planned Terraform configuration in ${tfWorkingDir}"
    echo "${planOutput}"
    echo
    exit ${planExitCode}
  fi

  # Exit code of 2 indicates success with changes. Print the output, change the
  # exit code to 0, and mark that the plan has changes.
  if [ ${planExitCode} -eq 2 ]; then
    planExitCode=0
    planHasChanges=true
    planCommentStatus="Success"
    echo "plan: info: successfully planned Terraform configuration in ${tfWorkingDir}"
    echo "${planOutput}"
    echo
    if echo "${planOutput}" | egrep '^-{72}$' &> /dev/null; then
        planOutput=$(echo "${planOutput}" | sed -n -r '/-{72}/,/-{72}/{ /-{72}/d; p }')
    fi
    planOutput=$(echo "${planOutput}" | sed -r -e 's/^  \+/\+/g' | sed -r -e 's/^  ~/~/g' | sed -r -e 's/^  -/-/g')

     # If output is longer than max length (65536 characters), keep last part
    planOutput=$(echo "${planOutput}" | tail -c 65000 )
  fi

  # Exit code of !0 indicates failure.
  if [ ${planExitCode} -ne 0 ]; then
    echo "plan: error: failed to plan Terraform configuration in ${tfWorkingDir}"
    echo "${planOutput}"
    echo
  fi

  # Comment on the pull request if necessary.
  if [ "$GITHUB_EVENT_NAME" == "pull_request" ] && [ "${tfComment}" == "1" ] && ([ "${planHasChanges}" == "true" ] || [ "${planCommentStatus}" == "Failed" ]); then
    planCommentWrapper="#### \`terraform plan\` ${planCommentStatus}
<details><summary>Show Output</summary>

\`\`\`
${planOutput}
\`\`\`

</details>

*Workflow: \`${GITHUB_WORKFLOW}\`, Action: \`${GITHUB_ACTION}\`, Working Directory: \`${tfWorkingDir}\`*"

    planCommentWrapper=$(stripColors "${planCommentWrapper}")
    echo "plan: info: creating JSON"
    planPayload=$(echo "${planCommentWrapper}" | jq -R --slurp '{body: .}')
    planCommentsURL=$(cat ${GITHUB_EVENT_PATH} | jq -r .pull_request.comments_url)
    echo "plan: info: commenting on the pull request"
    echo "${planPayload}" | curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" --header "Content-Type: application/json" --data @- "${planCommentsURL}" > /dev/null
  fi

  echo ::set-output name=tf_actions_plan_has_changes::${planHasChanges}
  exit ${planExitCode}
}
