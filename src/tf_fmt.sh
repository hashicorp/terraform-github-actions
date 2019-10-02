#!/bin/bash

function terraformFmt {

  echo "Checking if Terraform files in ${tfWorkingDir} are correctly formatted"
  fmtOutput=$(terraform fmt -check -write=false -diff -recursive ${tfWorkingDir})
  fmtExitCode=${?}
  
  # Exit code of 0 indicates all files are formatted correctly.
  if [ ${fmtExitCode} -eq 0 ]; then
    echo "Terraform files in ${tfWorkingDir} are correctly formatted"
    exit ${fmtExitCode} 
  # Exit code of 2 indicates a parse error. Print the output and exit 2.
  elif [ "${fmtExitCode}" -eq 2 ]; then
    echo "${fmtOutput}"
    exit ${fmtExitCode}
  # Otherwise, gather a list of incorrectly formatted files and output them.
  else
    echo "Terraform files in ${tfWorkingDir} are incorrectly formatted"
    echo "${fmtOutput}"
    echo "The following files are incorrectly formatted"
    fmtFileList=$(terraform fmt -check -write=false -list -recursive ${tfWorkingDir} 2>&1)
    echo "${fmtFileList}"
    exit ${fmtExitCode}
  fi
}
