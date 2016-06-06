# Docker container with Jenkins Continuous Integration and Delivery service

[![forthebadge](http://forthebadge.com/images/badges/built-by-developers.svg)](http://www.mobilesnapp.com)

This is a fully functional Jenkins server, based on the Long Term Support release http://jenkins.io/.
Sets up a container with jenkins installed listening on ports 8080 and 50000.

## Usage

    docker run -p 8080:8080 -p 50000:50000 mobilesnapp/jenkins

This will store the workspace in /var/jenkins_home. All Jenkins data lives in there - including plugins and configuration. You will probably want to make that a persistent volume (recommended):

    docker run -p 8080:8080 -p 50000:50000 -v /data/jenkins:/var/jenkins_home mobilesnapp/jenkins

This will store the jenkins data in /data/jenkins on the host. Ensure that /data/jenkins is accessible by the jenkins user in container (jenkins user - uid 1000) or use -u some_other_user parameter with docker run.

You can also use a volume container:

    docker run --name myjenkins -p 8080:8080 -p 50000:50000 -v /var/jenkins_home mobilesnapp/jenkins

To run the container with setup options:

    docker run -t -p 8080:8080 -p 5000:5000 -v /data/jenkins:/var/jenkins_home --name myjenkins --privileged=true --name container-jenkins mobilesnapp/jenkins
    
    docker ps
    CONTAINER ID        IMAGE                        COMMAND             CREATED             STATUS              PORTS                                            NAMES
    1bbd1309da52        mobilesnapp/jenkins   "/bin/bash"         8 minutes ago       Up 37 seconds       0.0.0.0:5000->5000/tcp, 0.0.0.0:8080->8080/tcp   container-jenkins

Your jenkins instance is now available by going to http://localhost:8080.

## Persistent Configuration

By default, JENKINS_HOME is set to /var/jenkins_home. The best way to persist or import configuration is to have a separate data volume for /var/jenkins_home. Reference on data volumes found here: https://docs.docker.com/engine/userguide/containers/dockervolumes/.

You can also assign volumes when you run the container:

    docker run -t -p 8080:8080 -p 5000:5000 -v /data/jenkins:/var/jenkins_home --name myjenkins --privileged=true --name container-jenkins mobilesnapp/jenkins

The container will link to '/data/jenkins' directory on the host machine.

## Backing up data

If you bind mount in a volume - you can simply back up that directory (which is jenkins_home) at any time.

This is highly recommended. Treat the jenkins_home directory as you would a database - in Docker you would generally put a database on a volume.

If your volume is inside a container - you can use docker cp $ID:/var/jenkins_home command to extract the data, or other options to find where the volume data is. Note that some symlinks on some OSes may be converted to copies (this can confuse jenkins with lastStableBuild links etc)

For more info check Docker docs section on Managing data (https://docs.docker.com/engine/userguide/containers/dockervolumes/) in containers.

## Setting the number of executors

You can specify and set the number of executors of your Jenkins master instance using a groovy script. By default its set to 2 executors, but you can extend the image and change it to your desired number of executors :

    executors.groovy

    import jenkins.model.*
    Jenkins.instance.setNumExecutors(5)

and Dockerfile

    FROM jenkins
    COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

## Attaching build executors

You can run builds on the master (out of the box) but if you want to attach build slave servers: make sure you map the port: -p 50000:50000 - which will be used when you connect a slave agent.

## Passing JVM parameters

You might need to customize the JVM running Jenkins, typically to pass system properties or tweak heap memory settings. Use JAVA_OPTS environment variable for this purpose :

    docker run --name myjenkins -p 8080:8080 -p 50000:50000 --env JAVA_OPTS=-Dhudson.footerURL=http://mycompany.com mobilesnapp/jenkins

## Configuring logging

Jenkins logging can be configured through a properties file and java.util.logging.config.file Java property. For example:

    mkdir data
    cat > data/log.properties <<EOF
    handlers=java.util.logging.ConsoleHandler
    jenkins.level=FINEST
    java.util.logging.ConsoleHandler.level=FINEST
    EOF
    docker run --name myjenkins -p 8080:8080 -p 50000:50000 --env JAVA_OPTS="-Djava.util.logging.config.file=/var/jenkins_home/log.properties" -v `pwd`/data:/var/jenkins_home mobilesnapp/jenkins

## Installing more tools

You can run your container as root - and install via apt-get, install as part of build steps via jenkins tool installers, or you can create your own Dockerfile to customise, for example:

    FROM jenkins
    # if we want to install via apt
    USER root
    RUN apt-get update && apt-get install -y ruby make more-thing-here
    USER jenkins # drop back to the regular jenkins user - good practice

In such a derived image, you can customize your jenkins instance with hook scripts or additional plugins. For this purpose, use /usr/share/jenkins/ref as a place to define the default JENKINS_HOME content you wish the target installation to look like :

    FROM jenkins
    COPY plugins.txt /usr/share/jenkins/ref/
    COPY custom.groovy /usr/share/jenkins/ref/init.groovy.d/custom.groovy
    RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

When jenkins container starts, it will check JENKINS_HOME has this reference content, and copy them there if required. It will not override such files, so if you upgraded some plugins from UI they won't be reverted on next start.

For your convenience, you also can use a plain text file to define plugins to be installed (using core-support plugin format). All plugins need to be listed as there is no transitive dependency resolution.

    pluginID:version
    credentials:1.18
    maven-plugin:2.7.1
    ...

And in derived Dockerfile just invoke the utility plugin.sh script

    FROM jenkins
    COPY plugins.txt /usr/share/jenkins/plugins.txt
    RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt


## Author

  * MobileSnapp (<support@mobilesnapp.com>)
