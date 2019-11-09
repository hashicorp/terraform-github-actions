#!/bin/bash

function terraformFmt {
  # Eliminate `-recursive` option for Terraform 0.11.x.
  fmtRecursive="-recursive"
  if hasPrefix "0.11" "${tfVersion}"; then
    fmtRecursive=""
  fi

  # Gather the output of `terraform fmt`.
  echo "fmt: info: checking if Terraform files in ${tfWorkingDir} are correctly formatted"
  fmtOutput=$(terraform fmt -check=true -write=false -diff ${fmtRecursive} ${*} 2>&1)
  fmtExitCode=${?}

  # Exit code of 0 indicates success. Print the output and exit.
  if [ ${fmtExitCode} -eq 0 ]; then
    echo "fmt: info: Terraform files in ${tfWorkingDir} are correctly formatted"
    echo "${fmtOutput}"
    echo
    exit ${fmtExitCode}
  fi

  # Exit code of 2 indicates a parse error. Print the output and exit.
  if [ ${fmtExitCode} -eq 2 ]; then
    echo "fmt: error: failed to parse Terraform files"
    echo "${fmtOutput}"
    echo
    exit ${fmtExitCode}
  fi

  # Exit code of !0 and !2 indicates failure.
  echo "fmt: error: Terraform files in ${tfWorkingDir} are incorrectly formatted"
  echo "${fmtOutput}"
  echo
  echo "fmt: error: the following files in ${tfWorkingDir} are incorrectly formatted"
  fmtFileList=$(terraform fmt -check=true -write=false -list ${fmtRecursive})
  echo "${fmtFileList}"
  echo

  # Comment on the pull request if necessary.
  if [ "$GITHUB_EVENT_NAME" == "pull_request" ] && [ "${tfComment}" == "1" ]; then
    fmtComment=""
    for file in ${fmtFileList}; do
      fmtFileDiff=$(terraform fmt -check=true -write=false -diff "${file}" | sed -n '/@@.*/,//{/@@.*/d;p}')
      fmtComment="${fmtComment}
<details><summary><code>${tfWorkingDir}/${file}</code></summary>

\`\`\`diff
${fmtFileDiff}
\`\`\`

</details>"

    done

    fmtCommentWrapper="#### \`terraform fmt\` Failed
${fmtComment}

*Workflow: \`${GITHUB_WORKFLOW}\`, Action: \`${GITHUB_ACTION}\`, Working Directory: \`${tfWorkingDir}\`*"

    fmtCommentWrapper=$(stripColors "${fmtCommentWrapper}")
    echo "fmt: info: creating JSON"
    fmtPayload=$(echo "${fmtCommentWrapper}" | jq -R --slurp '{body: .}')
    fmtCommentsURL=$(cat ${GITHUB_EVENT_PATH} | jq -r .pull_request.comments_url)
    echo "fmt: info: commenting on the pull request"
    echo "${fmtPayload}" | curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" --header "Content-Type: application/json" --data @- "${fmtCommentsURL}" > /dev/null
  fi

  exit ${fmtExitCode}
}
