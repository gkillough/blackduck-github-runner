# Overview
A docker image of a GitHub Runner, optimized for running [synopsys-detect](https://github.com/blackducksoftware/synopsys-detect).

# How To Build
```bash
# From the project directory
docker build -t blackduck-github-runner . 
```

# How To Use
```bash
docker run blackduck-github-runner [GitHub Repo URL] [GitHub Runner Token]
```
## Example
```bash
docker run blackduck-github-runner https://github.com/gkillough/blackduck-github-runner ABCDEFG12345HIJKLMNOP67890
```