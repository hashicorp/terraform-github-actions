#!/bin/bash

function terraformOutput {
  # Gather the output of `terraform output`.
  echo "output: info: gathering all the outputs for the Terraform configuration in ${tfWorkingDir}"
  outputOutput=$(terraform output -json ${*} 2>&1)
  outputExitCode=${?}

  # Exit code of 0 indicates success. Print the output and exit.
  if [ ${outputExitCode} -eq 0 ]; then
    echo "output: info: successfully gathered all the outputs for the Terraform configuration in ${tfWorkingDir}"
    echo "${outputOutput}"
    echo

    # https://github.community/t5/GitHub-Actions/set-output-Truncates-Multiline-Strings/m-p/38372/highlight/true#M3322
    outputOutput="${outputOutput//'%'/'%25'}"
    outputOutput="${outputOutput//$'\n'/'%0A'}"
    outputOutput="${outputOutput//$'\r'/'%0D'}"

    echo "::set-output name=tf_actions_output::${outputOutput}"
    exit ${outputExitCode}
  fi

  # Exit code of !0 indicates failure.
  echo "output: error: failed to gather all the outputs for the Terraform configuration in ${tfWorkingDir}"
  echo "${outputOutput}"
  echo
  exit ${outputExitCode}
}
