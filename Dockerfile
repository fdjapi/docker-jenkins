FROM openjdk:11-jre-slim

ENV SONAR_VERSION=9.2.1.47142 \
    SONARQUBE_HOME=/opt/sonarqube \
    # Database configuration
    # Defaults to using H2
    # Use values corresponding to your database
    # For more info, see https://docs.sonarqube.org/latest/setup/install-server/
    sonar.jdbc.username=sonar \
    sonar.jdbc.password=sonar \
    sonar.jdbc.url=jdbc:h2:tcp://localhost:9092/sonar

# Install required tools
RUN apt-get update && apt-get install -y gnupg curl unzip

# Download and verify SonarQube
RUN set -x \
    && cd /tmp \
    && curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.2.1.47142.zip \
    && curl -o sonarqube.zip.asc -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.2.1.47142.zip.asc \
    && gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys 8C8A14D94C1A49BE \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION $SONARQUBE_HOME \
    && rm sonarqube.zip* \
    && rm -rf $SONARQUBE_HOME/bin/*

# Expose default port
EXPOSE 9000

# Start SonarQube
ENTRYPOINT ["sh", "-c", "$SONARQUBE_HOME/bin/run.sh"]
