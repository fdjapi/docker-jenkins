FROM openjdk:11-jdk

LABEL maintainer="Your Name <youremail@example.com>"

ENV SONAR_VERSION=9.2.1.47142 \
    SONARQUBE_HOME=/opt/sonarqube \
    JDBC_POSTGRESQL_VERSION=42.2.16

# Install required packages
RUN apt-get update \
    && apt-get install -y gnupg unzip curl bash fontconfig \
    && rm -rf /var/lib/apt/lists/*

# Download and verify SonarQube
RUN cd /tmp \
    && curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && curl -o sonarqube.zip.asc -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
    && gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys 8C8A14D94C1A49BE \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION $SONARQUBE_HOME \
    && rm sonarqube.zip* \
    && rm -rf $SONARQUBE_HOME/bin/*

# Download JDBC driver for PostgreSQL
RUN curl -o $SONARQUBE_HOME/extensions/jdbc-driver/postgresql.jar -fSL https://jdbc.postgresql.org/download/postgresql-$JDBC_POSTGRESQL_VERSION.jar

# Copy custom configuration
COPY sonar.properties $SONARQUBE_HOME/conf/sonar.properties

# Set permissions
RUN chmod -R 777 $SONARQUBE_HOME/data $SONARQUBE_HOME/logs $SONARQUBE_HOME/extensions

WORKDIR $SONARQUBE_HOME
EXPOSE 9000

ENTRYPOINT ["./bin/run.sh"]
