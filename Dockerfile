FROM openjdk:8-jdk-alpine

ARG SONAR_VERSION=8.9.3.48735
ENV SONARQUBE_HOME=/opt/sonarqube

RUN apk add --no-cache curl gnupg \
    && cd /tmp \
    && curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && curl -o sonarqube.zip.asc -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
    && gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys 9C71D62B643B92B8 \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION $SONARQUBE_HOME \
    && rm sonarqube.zip* \
    && rm -rf $SONARQUBE_HOME/bin/*

EXPOSE 9000/tcp

CMD ["java", "-jar", "/opt/sonarqube/lib/sonar-application-$SONAR_VERSION.jar", "-Dsonar.log.console=true"]
