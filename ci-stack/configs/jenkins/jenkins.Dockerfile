ARG JENKINS_IMAGE
FROM ${JENKINS_IMAGE}
COPY jenkins/plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY jenkins/init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
