############################################
# Dockerfile to build Jenkins service image
############################################
# Base image
FROM ubuntu:14.04

# Author: MobileSnapp Inc.
MAINTAINER MobileSnapp <support@mobilesnapp.com>

# Install essentials.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget && \
  apt-get install -y openjdk-7-jdk && \
  apt-get --no-install-recommends install -q -y openjdk-7-jre-headless && \
  rm -rf /var/lib/apt/lists/*

# Add files.
ADD root/.bashrc /root/.bashrc
ADD root/.gitconfig /root/.gitconfig
ADD root/.scripts /root/.scripts
ADD http://mirrors.jenkins-ci.org/war/2.4/jenkins.war /opt/jenkins.war

RUN chmod 644 /opt/jenkins.war

# Set environment variables.
ENV HOME /root
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV JENKINS_HOME /jenkins

# Define working directory.
WORKDIR /data

ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]

# expose port 8080
EXPOSE 8080

# Define default command.
CMD ["bash"]