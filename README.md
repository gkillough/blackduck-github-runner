# Overview
A docker image of a GitHub Runner, optimized for running [synopsys-detect](https://github.com/blackducksoftware/synopsys-detect).

# How To Use
```bash
docker run IMAGE [GitHub Repo URL] [GitHub Runner Token]
```
## Example
```bash
docker run c0c05582e433 https://github.com/gkillough/blackduck-github-runner ABCDEFG12345HIJKLMNOP67890
```