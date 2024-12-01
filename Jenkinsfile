@Library('releng-pipeline') _

pipeline {
    agent any
    environment {
        HOME = "${env.WORKSPACE}"
    }
    stages {
        stage('build') {
            agent {
                kubernetes {
                    label 'basic-ubuntu'
                    yaml loadOverridableResource(
                        libraryResource: 'org/eclipsefdn/container/agent.yml'
                    )
                }
            }
            steps {
                container('containertools') {
                    containerBuild(
                        credentialsId: 'quay-bot',
                        name: 'quay.io/eclipse4diac/4diac-fortebuildcontainer',
                        version: 'latest'
                    )
                }
            }
        }
    }
}
