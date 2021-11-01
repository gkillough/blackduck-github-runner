#!/bin/bash

defaultGithubRunnerVersion="2.283.3"
defaultSynopsysDetectVersion="7.7.0"

githubRepoUrl="${1}"
githubRunnerToken="${2}"
githubRunnerVersion="${defaultGithubRunnerVersion}"
githubRunnerGroup="${GITHUB_RUNNER_GROUP}"
githubRunnerName="${GITHUB_RUNNER_NAME}"
githubRunnerTags="${GITHUB_RUNNER_TAGS:-synopsys-detect}"
githubRunnerWorkDir="${GITHUB_RUNNER_WORK_DIR}"
synopsysDetectVersion="${SYNOPSYS_DETECT_VERSION:-${defaultSynopsysDetectVersion}}"

# Validate Input
if [ -z ${githubRunnerToken} ] then
    echo "githubRunnerToken required"
    exit 1
fi
if [ -z ${githubRepoUrl} ] then
    echo "githubRepoUrl required"
    exit 1
fi

# Download Linux Runner
echo "Creating actions-runner directory..."
mkdir actions-runner && cd actions-runner
echo "Downloading version ${githubRunnerVersion} of the GitHub Runner..."
curl -o actions-runner-linux-x64-${githubRunnerVersion}.tar.gz -L https://github.com/actions/runner/releases/download/v${githubRunnerVersion}/actions-runner-linux-x64-${githubRunnerVersion}.tar.gz

# Validate Download
if [ ${githubRunnerVersion} = ${defaultGithubRunnerVersion} ] then
    echo "09aa49b96a8cbe75878dfcdc4f6d313e430d9f92b1f4625116b117a21caaba89  actions-runner-linux-x64-${githubRunnerVersion}.tar.gz" | shasum -a 256 -c
else
    echo "WARNING: Using non-default version of GitHub Runner (${githubRunnerVersion}), validation will be skipped"
fi

# Extract the installer
echo "Extracting installer..."
tar xzf ./actions-runner-linux-x64-${githubRunnerVersion}.tar.gz

# Configure runner
echo "Configuring runner..."
./config.sh \
 --unattended
 --url ${githubRepoUrl} \
 --token ${githubRunnerToken} \
 --runnergroup ${githubRunnerGroup} \
 --name ${githubRunnerName} \
 --labels ${githubRunnerTags} \
 --work ${githubRunnerWorkDir}

# Download Detect
 curl --silent -w "%{http_code}" -L -o /synopsys-detect.jar --create-dirs ${DETECT_SOURCE} \
    && if [[ ! -f /synopsys-detect.jar ]]; then echo "Unable to download Detect ${synopsysDetectVersion} jar" && exit -1 ; fi

./run.sh