# See if this is a CI environment.
# Appveyor has CI set to "true"
If ("${CI}" -eq "true")
{
     Write-Host "This is a continuous integration environment."
}
Else
{
     Write-Host "This is not a continuous integration environment."
}


# CI_HOST
if [[ "${APPVEYOR}" == "true" ]]; then
     CI_HOST="appveyor"
else
     printf "Unable to determine CI host."
fi

CI_API_URL="${APPVEYOR_API_URL}"

CI_PROJECT_ID="${APPVEYOR_PROJECT_ID}"

CI_PROJECT_NAME="${APPVEYOR_PROJECT_NAME}"

CI_PROJECT_SLUG="${APPVEYOR_PROJECT_SLUG}"

CI_BUILD_DIRECTORY="${APPVEYOR_BUILD_FOLDER}"

CI_BIULD_ID="${APPVEYOR_BUILD_ID}"

CI_BUILD_NUMBER="${APPVEYOR_BUILD_NUMBER}"

CI_BUILD_VERSION="${APPVEYOR_BUILD_VERSION}"

# CI_PULL_REQUEST_BOOLEAN
if [[ "${APPVEYOR_PULL_REQUEST_NUMBER}" == "" ]]; then
     CI_PULL_REQUEST_BOOLEAN="false"
elif [[ "${APPVEYOR_PULL_REQUEST_NUMBER}" =~ ^-?[0-9]+$ ]]; then
     CI_PULL_REQUEST_BOOLEAN="true"
else
     printf "Unable to determine pull request status."
fi

# CI_PULL_REQUEST_NUMBER
if [[ "${APPVEYOR_PULL_REQUEST_NUMBER}" == "" ]]; then
     CI_PULL_REQUEST_NUMBER="N/A"
elif [[ "${APPVEYOR_PULL_REQUEST_NUMBER}" =~ ^-?[0-9]+$ ]]; then
     CI_PULL_REQUEST_NUMBER="${APPVEYOR_PULL_REQUEST_NUMBER}"
else
     printf "Unable to determine pull request number."
fi

CI_PULL_REQUEST_TITLE="${APPVEYOR_PULL_REQUEST_TITLE}"

CI_JOB_ID="${APPVEYOR_JOB_ID}"

CI_REPOSITORY_PROVIDER="${APPVEYOR_REPO_PROVIDER}"

CI_REPOSITORY_SCM="${APPVEYOR_REPO_SCM}"

CI_REPOSITORY_NAME="${APPVEYOR_REPO_NAME}"

CI_REPOSITORY_BRANCH="${APPVEYOR_REPO_BRANCH}"

CI_REPOSITORY_PULL_ID="${APPVEYOR_REPO_COMMIT}"

CI_REPOSITORY_PULL_AUTHOR="${APPVEYOR_REPO_COMMIT_AUTHOR}"

CI_REPOSITORY_PULL_EMAIL="${APPVEYOR_REPO_COMMIT_AUTHOR_EMAIL}"

CI_REPOSITORY_PULL_TIMESTAMP="${PPVEYOR_REPO_COMMIT_TIMESTAMP}"

CI_REPOSITORY_PULL_MESSAGE_SHORT="${APPVEYOR_REPO_COMMIT_MESSAGE}"

CI_REPOSITORY_PULL_MESSAGE_FULL="${APPVEYOR_REPO_COMMIT_MESSAGE_EXTENDED}"

CI_BUILD_SCHEDULE_BOOLEAN="${APPVEYOR_SCHEDULED_BUILD}"

CI_BUILD_COMPILER_PLATFORM="${PLATFORM}"

CI_BUILD_COMPILER_CONFIGURATION="${CONFIGURATION}"

CI_REPOSITORY_PUSH_AUTHOR="AppVeyor"

CI_REPOSITORY_PUSH_EMAIL="appveyor@appveyor.com"




# ${BUILD_OS} is supplied by the YAML file.
CI_BIULD_OS="{BUILD_OS}"

# ${GH_TOKEN} is supplied by the YAML file.

# Temporary variable
CI_PULL_REQUEST_BOOLEAN_ALLOWED="\"true\" \"false\" \"no data\""



