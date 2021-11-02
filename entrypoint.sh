#!/bin/bash

defaultGithubRunnerVersion="2.283.3"
defaultSynopsysDetectVersion="7.7.0"

githubRepoUrl="${1}"
githubRunnerToken="${2}"
githubRunnerVersion="${defaultGithubRunnerVersion}"
githubRunnerGroup="${GITHUB_RUNNER_GROUP}"
githubRunnerName="${GITHUB_RUNNER_NAME}"
githubRunnerTags="${GITHUB_RUNNER_TAGS:=synopsys-detect}"
githubRunnerWorkDir="${GITHUB_RUNNER_WORK_DIR}"

synopsysDetectVersion="${SYNOPSYS_DETECT_VERSION:=${defaultSynopsysDetectVersion}}"
synopsysDetectDownloadUrl="${SYNOPSYS_DETECT_DOWNLOAD_URL:=https://sig-repo.synopsys.com/bds-integrations-release/com/synopsys/integration/synopsys-detect/${defaultSynopsysDetectVersion}/synopsys-detect-${defaultSynopsysDetectVersion}.jar}"
synopsysDetectJarLocation=/synopsys-detect.jar

# Validate Input
if [ -z ${githubRunnerToken} ]; then
    echo "githubRunnerToken required"
    exit 1
fi
if [ -z ${githubRepoUrl} ]; then
    echo "githubRepoUrl required"
    exit 1
fi

# Download linux runner
echo "Creating actions-runner directory..."
mkdir actions-runner && cd actions-runner
echo "Downloading version ${githubRunnerVersion} of the GitHub Runner..."
curl -o actions-runner-linux-x64-${githubRunnerVersion}.tar.gz -L https://github.com/actions/runner/releases/download/v${githubRunnerVersion}/actions-runner-linux-x64-${githubRunnerVersion}.tar.gz

# Extract the installer
echo "Extracting installer..."
tar xzf ./actions-runner-linux-x64-${githubRunnerVersion}.tar.gz

# Configure runner
echo "Configuring runner..."
./config.sh \
 --unattended \
 --url ${githubRepoUrl} \
 --token ${githubRunnerToken} \
 --runnergroup ${githubRunnerGroup} \
 --name ${githubRunnerName} \
 --labels ${githubRunnerTags} \
 --work ${githubRunnerWorkDir}

# Setup Detect
if [ ! -f ${synopsysDetectJarLocation} ]; then
    echo "Downloading Detect..."
    curl --silent -w "%{http_code}\n" -L -o ${synopsysDetectJarLocation} --create-dirs ${synopsysDetectDownloadUrl} \
        && if [[ ! -f ${synopsysDetectJarLocation} ]]; then echo "Unable to download Detect ${synopsysDetectVersion} jar" && exit -1 ; fi
else
    echo "Detect is already downloaded"
fi

# Start the runner
echo "Starting GitHub Linux Runner version ${githubRunnerVersion}"
./run.sh