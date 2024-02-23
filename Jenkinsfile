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
                    yaml loadOverridableResource(
                        libraryResource: 'org/eclipsefdn/container/agent.yml'
                    )
                }
            }
            steps {
                container('containertools') {
                    containerBuild(
                        credentialsId: 'eclipse4diac+bot',
                        name: 'https://quay.io/repository/eclipse4diac/4diac-fortebuildcontainer',
                        version: 'latest'
                    )
                }
            }
        }
    }
}
