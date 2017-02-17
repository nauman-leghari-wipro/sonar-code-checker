set -e

CWD=$(pwd)

mkdir -vp .code
cd .code

GIT_URL="$1"

if [[ $# -lt 1 ]]; then
  echo >&2 "Argument missing: URL to git repository"
  exit 1
fi

REPO_NAME=$(basename $GIT_URL .git)

echo "Cloning git repo: $REPO_NAME"

if [ -d "$REPO_NAME" ]; then
	cd $REPO_NAME
	git pull
else
	git clone $GIT_URL
	cd $REPO_NAME
fi

cat > sonar-project.properties <<EOL
# must be unique in a given SonarQube instance
sonar.projectKey=$REPO_NAME
sonar.projectName=$REPO_NAME
sonar.sources=.
EOL

docker run --rm --link sonarqube:sonarqube --entrypoint /opt/sonar-runner-2.4/bin/sonar-runner -e SONAR_USER_HOME=/data/.sonar-cache -v $(pwd):/data buildit/sonar-runner -Dsonar.host.url=http://sonarqube:9000

cd $CWD

echo "Navigating to SonarQube projects"
SONARQUBE_PORT=$(docker inspect sonarqube | jq -r '.[].NetworkSettings.Ports["9000/tcp"][0].HostPort')

DOCKER_IP="localhost"

if command -v docker-machine; then
	DOCKER_IP=$(docker-machine ip default)
fi

open "http://$DOCKER_IP:$SONARQUBE_PORT/projects"
