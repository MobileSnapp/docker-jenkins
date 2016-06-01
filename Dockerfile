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
  apt-get update -q && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget && \
  apt-get --no-install-recommends install -q -y openjdk-7-jre-headless && \
  apt-get install git curl wget mysql-client -y -q && \
  rm -rf /var/lib/apt/lists/*

# Add files.
ADD root/.bashrc /root/.bashrc
ADD root/.gitconfig /root/.gitconfig
ADD root/.scripts /root/.scripts

# Set environment variables.
ENV HOME /root
ENV JENKINS_PREFIX /
ENV JENKINS_HOME /opt/jenkins/jenkins_home
ENV JAVA_ARGS -Xmx2048m -XX:MaxPermSize=512m

RUN mkdir -p /opt/jenkins

RUN groupadd -g 505 jenkins
RUN useradd -m -u 505 -g 505 -d $JENKINS_HOME jenkins

RUN chown -R jenkins:jenkins $JENKINS_HOME && chown -R jenkins:jenkins /opt/jenkins
RUN wget -q -O /opt/jenkins/jenkins.war http://mirrors.jenkins-ci.org/war/latest/jenkins.war
USER jenkins
CMD exec java $JAVA_ARGS -jar $JENKINS_HOME/../jenkins.war --prefix=$JENKINS_PREFIX

# expose ports
EXPOSE 50000/tcp
EXPOSE 8080/tcp
