#!/bin/bash

function terraformValidate {
  echo "validate: validating Terraform configuration in ${tfWorkingDir}"
  validateOutput=$(terraform validate)
  validateExitCode=${?}
  
  # Exit code of 0 indicates success.
  if [ ${validateExitCode} -eq 0 ]; then
    echo "validate: successfully validated Terraform configuration in ${tfWorkingDir}"
    echo "${validateOutput}"
    echo
    exit ${validateExitCode}
  # Otherwise, print the output and exit.
  else
    echo "validate: failed to validate Terraform configuration in ${tfWorkingDir}"
    echo "${validateOutput}"
    echo
    exit ${validateExitCode}
  fi
}
