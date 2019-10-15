#!/bin/bash

scriptDir=$(dirname ${0})

source ${scriptDir}/terraform_fmt.sh

function parseInputs {
 
  # Required inputs
  if [ "${INPUT_TF_ACTIONS_VERSION}" != "" ]; then
    tfVersion=${INPUT_TF_ACTIONS_VERSION}
  else
    echo "Input terraform_version cannot be empty"
    exit 1
  fi

  if [ "${INPUT_TF_ACTIONS_SUBCOMMAND}" != "" ]; then
    tfSubcommand=${INPUT_TF_ACTIONS_SUBCOMMAND}
  else
    echo "Input terraform_subcommand cannot be empty"
    exit 1
  fi
 
  # Optional inputs
  if [ "${INPUT_TF_ACTIONS_WORKING_DIR}" == "" ] || [ "${INPUT_TF_ACTIONS_WORKING_DIR}" == "." ]; then
    tfWorkingDir=${GITHUB_WORKSPACE}
  else
    tfWorkingDir=${GITHUB_WORKSPACE}/${INPUT_TF_ACTIONS_WORKING_DIR}
  fi
}


function installTerraform {
  url="https://releases.hashicorp.com/terraform/${tfVersion}/terraform_${tfVersion}_linux_amd64.zip"

  echo "Downloading Terraform v${tfVersion}"
  curl -s -S -L -o /tmp/terraform_${tfVersion} ${url}
  if [ "${?}" -ne 0 ]; then
    echo "Failed to download Terraform v${tfVersion}"
    exit 1
  fi
  echo "Successfully downloaded Terraform v${tfVersion}"

  echo "Unzipping Terraform v${tfVersion}"
  unzip -d /usr/local/bin /tmp/terraform_${tfVersion} > /dev/null 2>&1
  if [ "${?}" -ne 0 ]; then
    echo "Failed to unzip Terraform v${tfVersion}"
    exit 1
  fi
  echo "Successfully unzipped Terraform v${tfVersion}"
}

parseInputs
cd ${tfWorkingDir}

case "${tfSubcommand}" in
  fmt)
    installTerraform
    terraformFmt
    ;;
  *)
    echo "Error: Must provide a valid value for terraform_subcommand"
    ;;
esac
