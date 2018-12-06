pipelineJob('DockerInDocker-build') {
  definition {
    cpsScm {
      scm {
        git {
          remote {
            url('https://github.com/amazurenko/jenkins-examples')
          }
        }
      }
      scriptPath('./jenkinsfile/withDockerTools/Jenkinsfile')
    }
  }
}
