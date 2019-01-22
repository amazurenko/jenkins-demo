FROM jenkins/ssh-slave
RUN apt-get update && apt-get install XXX
COPY your-favorite-tool-here
