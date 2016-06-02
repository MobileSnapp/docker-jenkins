# docker-jenkins

[![forthebadge](http://forthebadge.com/images/badges/built-by-developers.svg)](http://www.mobilesnapp.com)

Docker container with Jenkins service

Usage:

    docker run -t -p 8080:8080 -p 5000:5000 -v /data/jenkins:/opt/jenkins/jenkins_home --name jenkins --privileged=true --name container-jenkins docker-jenkins 
