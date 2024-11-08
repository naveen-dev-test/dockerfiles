@Library('cib-shared-library') _  // Import your shared library for Kaniko

properties([
    parameters([
        string(name: 'ARCHITECTURE', defaultValue: 'amd64', description: 'Specify architecture'),
        string(name: 'PROJECT', defaultValue: 'myproject', description: 'Project name'),
        string(name: 'DISTRIBUTION', defaultValue: 'latest', description: 'Distribution version'),
        string(name: 'DOCKER_SUFFIX', defaultValue: '', description: 'Optional suffix for the Docker image tag')
    ])
])

pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm // Checkout the current code from SCM
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Define the path to your single Dockerfile
                    def dockerfilePath = 'dockerfiles/bionic-amd64-tf-m-build/Dockerfile' // Update to your specific Dockerfile path
                    def imageTag = dockerfilePath.split('/')[2]  // Get the label name from the path
                    
                    // Set the image name based on your desired naming convention
                    def dockerImage = "navkum11/test:ci-${params.ARCHITECTURE}-${params.PROJECT}-${params.DISTRIBUTION}${params.DOCKER_SUFFIX}"

                    // Call the kanikoBuild function defined in your shared library
                    kanikoBuild(
                        dockerImage: dockerImage,  // Pass the full image name with tag
                        dockerRegistry: 'navkum11',  // Your actual Docker registry name
                        dockerRegistryCredentials: 'docker-credentials-id',  // Jenkins credentials ID for Docker registry
                        context: 'dockerfiles/bionic-amd64-tf-m-build',  // Build context based on the Dockerfile directory
                        dockerfile: 'Dockerfile'  // Direct reference to your single Dockerfile
                    )
                }
            }
        }
    }
}
