@Library('cib-shared-library') _  // Import your shared library for Kaniko

pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm // Checkout the current code from SCM
            }
        }

        stage('Build and Push Docker Images') {
            steps {
                script {
                    // Directory where all Dockerfiles are located
                    def dockerfilesDir = 'dockerfiles/bionic-amd64-tf-m-build' // Update to your specific directory
                    // Find all Dockerfiles in the specified directory
                    def files = findFiles(glob: "${dockerfilesDir}/Dockerfile")

                    // Check if any Dockerfile is found
                    if (files.isEmpty()) {
                        echo "No Dockerfiles found in ${dockerfilesDir}. Skipping build."
                        return
                    }

                    // Iterate over each Dockerfile and build/push an image
                    for (file in files) {
                        def dockerfilePath = file.path
                        def imageTag = dockerfilePath.split('/')[2]  // Get the label name from the path
                        
                        // Set the image name based on your desired naming convention
                        def dockerImage = "navkum11/test:ci-${ARCHITECTURE}-${PROJECT}-ubuntu:${DISTRIBUTION}${DOCKER_SUFFIX}"

                        // Call the kanikoBuild function defined in your shared library
                        kanikoBuild(
                            dockerImage: dockerImage,  // Pass the full image name with tag
                            dockerRegistry: 'navkum11',  // Your actual Docker registry name
                            dockerRegistryCredentials: 'docker-credentials-id',  // Jenkins credentials ID for Docker registry
                            context: dockerfilesDir,  // Build context based on the Dockerfiles directory
                            dockerfile: 'Dockerfile'  // Each Dockerfile should be named "Dockerfile"
                        )
                    }
                }
            }
        }
    }
}

