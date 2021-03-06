#!/usr/bin/env bash
# Requires Bash minimum version 3.1.0

# Modified script originally from http://sleepycoders.blogspot.com/2013/03/sharing-travis-ci-generated-files.html

# Currently makes the following assumptions:
#     The CI environment has all the necessary CI variables set.
#     The CI environment has the variable "${GH_TOKEN}" to connect to Github via OAuth token
#     All uploaded files are located in "${CI_BUILD_DIRECTORY}/release/"


if printf  "${CI_PULL_REQUEST_BOOLEAN_ALLOWED}" | grep -E "\"${CI_PULL_REQUEST_BOOLEAN}\"" > /dev/null; then
     if [ "${CI_PULL_REQUEST_BOOLEAN}" == "true" ]; then
         printf "Pull request\n"
         exit 0
     elif [ "${CI_PULL_REQUEST_BOOLEAN}" == "false" ]; then
         printf "Starting gh-pages update\n"
         
         printf "Setting up Git\n"
         cd ${CI_BUILD_DIRECTORY}
         test ! -d ./Git \
             && mkdir ./Git \
             && cd ./Git
         git config --global user.email "${CI_REPOSITORY_PUSH_EMAIL}"
         git config --global user.name "${CI_REPOSITORY_PUSH_AUTHOR}"
         
         printf "Connecting to gh-pages\n"
         git clone \
         --quiet \
         --branch=gh-pages \
             https://${GH_TOKEN}@github.com/${CI_REPOSITORY_NAME} \
         gh-pages > /dev/null
         
         printf "Copying new files\n"
         cd ./gh-pages
         test ! -d ./${CI_REPOSITORY_BRANCH}/${CI_BUILD_OS} \
             && mkdir -p ./${CI_REPOSITORY_BRANCH}/${CI_BUILD_OS}
         cp -Rf "${CI_BUILD_DIRECTORY}/release/"* "./${CI_REPOSITORY_BRANCH}/${CI_BUILD_OS}"
         
         printf "Committing and pushing files\n"
         git add -f .
         git commit -m "Build \"${CI_HOST}-${CI_BUILD_NUMBER}\""
         git push -fq origin gh-pages > /dev/null
         
         printf "Done\n"
         exit 0
     elif [ "${CI_PULL_REQUEST_BOOLEAN}" == "no data" ]; then
         printf "Warning: Unable to determine pull request status. Not pushing data.\n"
         exit 0
     else
         printf "Error: Variable \${CI_PULL_REQUEST_BOOLEAN} returned \"${CI_PULL_REQUEST_BOOLEAN}\". Expected values: \"true\" \"false\" \"no data\". This script is unprepared to handle \"${CI_PULL_REQUEST_BOOLEAN}\" but has determined that \"${CI_PULL_REQUEST_BOOLEAN}\" is an allowed value.\n"
         exit 1
     fi
elif env | grep -E "CI_PULL_REQUEST_BOOLEAN=" > /dev/null; then
     printf "Error: Variable \${CI_PULL_REQUEST_BOOLEAN} returned \"${CI_PULL_REQUEST_BOOLEAN}\". Expected values: ${CI_PULL_REQUEST_BOOLEAN_ALLOWED}.\n"
     exit 1
else
     printf "Error: Environment variable \${CI_PULL_REQUEST_BOOLEAN} not set.\n"
     exit 1
fi



