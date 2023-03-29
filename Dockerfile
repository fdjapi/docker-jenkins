# Use official OpenJDK 8 runtime as a parent image
FROM openjdk:8-jre-alpine

# Set environment variables
ENV SONAR_VERSION=8.9.3.48735 \
    SONARQUBE_HOME=/opt/sonarqube \
    PATH=$PATH:/opt/sonarqube/bin

# Download and verify SonarQube
RUN set -x \
    && cd /tmp \
    && curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && curl -o sonarqube.zip.asc -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
    && gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys 9C71D62B643B92B8 \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION $SONARQUBE_HOME \
    && rm sonarqube.zip* \
    && rm -rf $SONARQUBE_HOME/bin/*

# Expose default port
EXPOSE 9000

# Start SonarQube
ENTRYPOINT ["./bin/run.sh"]
CMD ["sonarqube"]
