#!/bin/bash

function terraformImport {
  # Gather the output of `terraform import`.
  echo "import: info: importing Terraform configuration in ${tfWorkingDir}"
  importOutput=$(terraform import -input=false ${*} 2>&1)
  importExitCode=${?}
  importCommentStatus="Failed"

  # Exit code of 0 indicates success with no changes. Print the output and exit.
  if [ ${importExitCode} -eq 0 ]; then
    echo "import: info: successfully imported Terraform configuration in ${tfWorkingDir}"
    echo "${importOutput}"
    echo
    exit ${importExitCode}
  fi

  # Exit code of !0 indicates failure.
  if [ ${importExitCode} -ne 0 ]; then
    echo "import: error: failed to import Terraform configuration in ${tfWorkingDir}"
    echo "${importOutput}"
    echo
  fi

  # Comment on the pull request if necessary.
  if [ "${tfComment}" == "1" ] && [ -n "${tfCommentUrl}" ] && [ "${importCommentStatus}" == "Failed" ]; then
    importCommentWrapper="#### \`terraform import\` ${importCommentStatus}
<details><summary>Show Output</summary>

\`\`\`
${importOutput}
\`\`\`

</details>

*Workflow: \`${GITHUB_WORKFLOW}\`, Action: \`${GITHUB_ACTION}\`, Working Directory: \`${tfWorkingDir}\`, Workspace: \`${tfWorkspace}\`*"

    importCommentWrapper=$(stripColors "${importCommentWrapper}")
    echo "import: info: creating JSON"
    importPayload=$(echo "${importCommentWrapper}" | jq -R --slurp '{body: .}')
    echo "import: info: commenting on the pull request"
    echo "${importPayload}" | curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" --header "Content-Type: application/json" --data @- "${tfCommentUrl}" > /dev/null
  fi

  exit ${importExitCode}
}
