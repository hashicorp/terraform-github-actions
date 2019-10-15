#!/bin/bash

function terraformInit {
  echo "init: initializing Terraform configuration in ${tfWorkingDir}"
  initOutput=$(terraform init -input=false)
  initExitCode=${?}
  
  # Exit code of 0 indicates success.
  if [ ${initExitCode} -eq 0 ]; then
    echo "init: successfully initialized Terraform configuration in ${tfWorkingDir}"
    echo "${initOutput}"
    echo
    exit ${initExitCode}
  # Otherwise, print the output and exit.
  else
    echo "init: failed to initialize Terraform configuration in ${tfWorkingDir}"
    echo "${initOutput}"
    echo
    exit ${initExitCode}
  fi
}
