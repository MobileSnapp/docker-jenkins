# docker-jenkins

[![forthebadge](http://forthebadge.com/images/badges/built-by-developers.svg)](http://www.mobilesnapp.com)

Docker container with Jenkins service
Sets up a container with jenkins installed listening on ports 8080 and 50000.

## Usage

To run the container, do the following:

    docker run -t -p 8080:8080 -p 5000:5000 -v /data/jenkins:/opt/jenkins/jenkins_home --name jenkins --privileged=true --name container-jenkins mobilesnapp/docker-jenkins
    
    docker ps
    CONTAINER ID        IMAGE                        COMMAND             CREATED             STATUS              PORTS                                            NAMES
1bbd1309da52        mobilesnapp/docker-jenkins   "/bin/bash"         8 minutes ago       Up 37 seconds       0.0.0.0:5000->5000/tcp, 0.0.0.0:8080->8080/tcp   container-jenkins

Your jenkins instance is now available by going to http://localhost:8080.

### Persistent Configuration

By default, JENKINS_HOME is set to /opt/jenkins/jenkins_home.  The best way to persist or import configuration is to have a separate data volume for /opt/jenkins/jenkins_home.  Below are a few references on data volumes.

  * https://docs.docker.com/userguide/dockervolumes/

You can also assign volumes when you run the container:

    docker run -t -p 8080:8080 -p 5000:5000 -v /data/jenkins:/data/jenkins:/opt/jenkins/jenkins_home --name jenkins --privileged=true --name container-jenkins mobilesnapp/docker-jenkins

The container will link to '/data/jenkins' directory on the host machine.

## Building

To build the image, simply invoke

    docker build github.com/MobileSnapp/docker-jenkins

A prebuilt container is also available in the docker index

    docker pull mobilesnapp/docker-jenkins


## Author

  * MobileSnapp (<support@mobilesnapp.com>)
