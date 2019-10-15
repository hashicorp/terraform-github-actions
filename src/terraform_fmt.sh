#!/bin/bash

function terraformFmt {
  echo "fmt: checking if Terraform files in ${tfWorkingDir} are correctly formatted"
  fmtOutput=$(terraform fmt -check -write=false -diff -recursive)
  fmtExitCode=${?}
  
  # Exit code of 0 indicates all files are formatted correctly.
  if [ ${fmtExitCode} -eq 0 ]; then
    echo "fmt: Terraform files in ${tfWorkingDir} are correctly formatted"
    exit ${fmtExitCode}
  # Exit code of 2 indicates a parse error. Print the output and exit 2.
  elif [ ${fmtExitCode} -eq 2 ]; then
    echo "${fmtOutput}"
    echo
    exit ${fmtExitCode}
  # Otherwise, gather a list of incorrectly formatted files and output them.
  else
    echo "fmt: terraform files in ${tfWorkingDir} are incorrectly formatted"
    echo "${fmtOutput}"
    echo
    echo "fmt: the following files in ${tfWorkingDir} are incorrectly formatted"
    fmtFileList=$(terraform fmt -check -write=false -list -recursive)
    echo "${fmtFileList}"
    echo
    exit ${fmtExitCode}
  fi
}
