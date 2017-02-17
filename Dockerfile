FROM java:openjdk-8u45-jre
MAINTAINER Nauman Leghari nauman.leghari@wipro.com - Forked from spujadas/sonar-runner-docker

ENV SONAR_RUNNER_VERSION 2.4
ENV SONAR_RUNNER_HOME /opt/sonar-runner-${SONAR_RUNNER_VERSION}
ENV SONAR_RUNNER_PACKAGE sonar-runner-dist-${SONAR_RUNNER_VERSION}.zip
ENV HOME ${SONAR_RUNNER_HOME}

WORKDIR /opt

RUN wget http://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/${SONAR_RUNNER_VERSION}/${SONAR_RUNNER_PACKAGE} \
 && unzip sonar-runner-dist-${SONAR_RUNNER_VERSION}.zip \
 && rm ${SONAR_RUNNER_PACKAGE}

RUN mkdir -p /data 

WORKDIR /data

VOLUME /data

ENTRYPOINT ${SONAR_RUNNER_HOME}/bin/sonar-runner
