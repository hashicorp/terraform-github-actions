#!/bin/bash

function terraformInit {
  # If tf_actions_init_create_workspace is true ("1"), we run init with the
  # `default` workspace and switch to / create the desired workspace. (This
  # works around the fact you can't list workspaces from an un-initialized
  # directory.)
  if [ ${tfInitCreateWorkspace} == "1" ]; then
    echo "init: info: pre-initializing Terraform configuration in ${tfWorkingDir}"
    preInitOutput=$(TF_WORKSPACE=default terraform init -input=false ${*} 2>&1)
    preInitExitCode=${?}

    if [ ${preInitExitCode} -ne 0 ]; then
      echo "init: error: failed to pre-init Terraform in ${tfWorkingDir}"
      echo "${preInitOutput}"
      # Rewrite tfWorkspace as a hint in the PR comment
      tfWorkspace="default (for ${tfWorkspace})" sendPRComment "${preInitOutput}"
      exit 1
    fi

    # We've initialized, now we should be able to access the list of workspaces
    workspaces=$(terraform workspace list | cut -c3-)
    if echo "${workspaces}" | grep -E -q "^${tfWorkspace}$"; then
      echo "init: info: Terraform workspace '${tfWorkspace}' already exists in ${tfWorkingDir}, not creating it"
    else
      echo "init: info: creating Terraform workspace '${tfWorkspace}'"
      createWorkspaceOutput=$(terraform workspace new "${tfWorkspace}" 2>&1)
      createWorkspaceExitCode=${?}
      if [ ${createWorkspaceExitCode} -eq 0 ]; then
        echo "init: info: successfully created Terraform workspace ${tfWorkspace} in ${tfWorkingDir}"
      else
        echo "init: error: failed to create Terraform workspace ${tfWorkspace} in ${tfWorkingDir}"
        echo "${createWorkspaceOutput}"
        echo
        exit ${createWorkspaceExitCode}
      fi
    fi
  fi

  echo "init: info: initializing Terraform configuration in ${tfWorkingDir}"
  initOutput=$(terraform init -input=false ${*} 2>&1)
  initExitCode=${?}

  # Exit code of 0 indicates success. Print the output and exit.
  if [ ${initExitCode} -eq 0 ]; then
    echo "init: info: successfully initialized Terraform configuration in ${tfWorkingDir}"
    echo "${initOutput}"
    echo
    exit ${initExitCode}
  fi

  # Exit code of !0 indicates failure.
  echo "init: error: failed to initialize Terraform configuration in ${tfWorkingDir}"
  echo "${initOutput}"
  echo

  sendPRComment "${initOutput}"

  exit ${initExitCode}
}
