# Overview
A docker image of a GitHub Runner, optimized for running [synopsys-detect](https://github.com/blackducksoftware/synopsys-detect).

# How To Build
```bash
# From the project directory
docker build -t blackduck-github-runner . 
```

# How To Use

## Option 1: Using with defaults
Invoking `docker run` will download the default GitHub Runner and Synopsys Detect JAR.
```bash
docker run --name [Container Name] blackduck-github-runner [GitHub Repo URL] [GitHub Runner Token]
```
### Example
```bash
docker run --name my-runner blackduck-github-runner https://github.com/gkillough/blackduck-github-runner ABCDEFG12345HIJKLMNOP67890
```

## Option 2: Create, copy, start
To avoid downloading files every run, the `docker cp` command can be used to add files to the default locations:
```bash
# Create the container
docker create --name [Container Name] blackduck-github-runner [GitHub Repo URL] [GitHub Runner Token]
# Copy the file(s)
docker cp [Local Synopsys Detect JAR] [Container Name]:/synopsys-detect.jar
# Start the container
docker start [Container Name]
# (Optional) Tail the logs
docker logs -f [Container Name]
```
### Example
```bash
docker create --name my-runner blackduck-github-runner https://github.com/gkillough/blackduck-github-runner ABCDEFG12345HIJKLMNOP67890
docker cp ~/Downloads/a-detect-jar.jar my-runner:/synopsys-detect.jar
docker start my-runner
docker logs -f my-runner
```