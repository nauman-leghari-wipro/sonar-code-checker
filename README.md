### Run sonar code analysis on a git project

Only tested on MacOS with Docker running in VirtualBox. For native docker installation, the docker-machine command probably won't work but the run-sonar.sh script should handle that scenario and defaults to localhost for docker ip.

##### Pre-requisites

```
docker
git
jq - https://stedolan.github.io/jq/
```

##### Clone this repo

```
git clone git@github.com:nauman-leghari-wipro/sonar-code-checker.git
```

[![asciicast](https://asciinema.org/a/104482.png)](https://asciinema.org/a/104482)

##### Build docker image for sonar-runner

```
docker build -t buildit/sonar-runner .
```

##### Run SonarQube

```
docker run -d -P --name sonarqube sonarqube
```

Watch logs for the container. Exit (Ctrl + C) when SonarQube is up

```
docker logs -f sonarqube
```

##### Run Analysis

```
./run-sonar.sh <git url>

eg.
./run-sonar.sh git@github.com:namuan/site-crawler.git
```

##### Open SonarQube

```
SONARQUBE_PORT=$(docker inspect sonarqube | jq -r '.[].NetworkSettings.Ports["9000/tcp"][0].HostPort')

open "http://$(docker-machine ip default):$SONARQUBE_PORT/projects"
```
