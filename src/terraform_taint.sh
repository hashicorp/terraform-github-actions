#!/bin/bash

function terraformTaint {
  # Gather the output of `terraform taint`.
  echo "taint: info: tainting Terraform configuration in ${tfWorkingDir}"
  #taintOutput=$(terraform taint ${*} 2>&1)
  taintOutput=$(for resource in ${*}; do terraform taint -allow-missing $resource; done 2>&1)
  taintExitCode=${?}
  taintCommentStatus="Failed"

  # Exit code of 0 indicates success with no changes. Print the output and exit.
  if [ ${taintExitCode} -eq 0 ]; then
    taintCommentStatus="Success"
    echo "taint: info: successfully tainted Terraform configuration in ${tfWorkingDir}"
    echo "${taintOutput}"
    echo
    exit ${taintExitCode}
  fi

  # Exit code of !0 indicates failure.
  if [ ${taintExitCode} -ne 0 ]; then
    echo "taint: error: failed to taint Terraform configuration in ${tfWorkingDir}"
    echo "${taintOutput}"
    echo
  fi

  # Comment on the pull request if necessary.
  if [ "${tfComment}" == "1" ] && [ -n "${tfCommentUrl}" ]; then
    taintCommentWrapper="#### \`terraform taint\` ${taintCommentStatus}
<details><summary>Show Output</summary>

\`\`\`
${taintOutput}
\`\`\`

</details>

*Workflow: \`${GITHUB_WORKFLOW}\`, Action: \`${GITHUB_ACTION}\`, Working Directory: \`${tfWorkingDir}\`, Workspace: \`${tfWorkspace}\`*"

    taintCommentWrapper=$(stripColors "${taintCommentWrapper}")
    echo "taint: info: creating JSON"
    taintPayload=$(echo "${taintCommentWrapper}" | jq -R --slurp '{body: .}')
    echo "taint: info: commenting on the pull request"
    echo "${taintPayload}" | curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" --header "Content-Type: application/json" --data @- "${tfCommentUrl}" > /dev/null
  fi

  exit ${taintExitCode}
}
