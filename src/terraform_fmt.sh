#!/bin/bash

function terraformFmt {
  echo "fmt: checking if Terraform files in ${tfWorkingDir} are correctly formatted"
  fmtOutput=$(terraform fmt -check -write=false -diff -recursive)
  fmtExitCode=${?}
  
  # Exit code of 0 indicates all files are formatted correctly.
  if [ ${fmtExitCode} -eq 0 ]; then
    echo "fmt: Terraform files in ${tfWorkingDir} are correctly formatted"
    echo "${fmtOutput}"
    echo
    exit ${fmtExitCode}
  # Exit code of 2 indicates a parse error. Print the output and exit 2.
  elif [ ${fmtExitCode} -eq 2 ]; then
    echo "${fmtOutput}"
    echo
    exit ${fmtExitCode}
  # Otherwise, output the incorrectly formatted files and comment if necessary.
  else
    echo "fmt: Terraform files in ${tfWorkingDir} are incorrectly formatted"
    echo "${fmtOutput}"
    echo
    # echo "fmt: the following files in ${tfWorkingDir} are incorrectly formatted"
    fmtFileList=$(terraform fmt -check -write=false -list -recursive)
    # echo "${fmtFileList}"
    # echo

    # Comment
    if [ "$GITHUB_EVENT_NAME" == "pull_request" ] && [ "${tfComment}" == "1" ]; then
      fmtComment=""
      for file in ${fmtFileList}; do
        fmtFileDiff=$(terraform fmt -check -write=false -diff "$file"  | sed -n '/@@.*/,//{/@@.*/d;p}')
        fmtComment="${fmtComment}
<details><summary><code>${tfWorkingDir}/${file}</code></summary>

\`\`\`diff
${fmtFileDiff}
\`\`\`
</details>
"
      done
      fmtCommentWrapper="#### \`terraform fmt\` Failed
${fmtComment}
*Workflow: \`${GITHUB_WORKFLOW}\`, Action: \`${GITHUB_ACTION}\`*
"
      fmtPayload=$(echo '{}' | jq --arg body "${fmtCommentWrapper}" '.body = $body')
      fmtCommentsURL=$(cat ${GITHUB_EVENT_PATH} | jq -r .pull_request.comments_url)
      curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" --header "Content-Type: application/json" --data "${fmtPayload}" "${fmtCommentsURL}" > /dev/null
    fi
    exit ${fmtExitCode}
  fi
}
