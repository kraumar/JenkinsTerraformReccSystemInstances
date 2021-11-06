pipeline {
    agent any

    parameters {
        string(name: 'BRANCH', defaultValue: params.BRANCH ?: 'master', description: 'branch to use')
        booleanParam(name: 'CLEANUP', defaultValue: false, description: 'do you want to perform cleanup')
    }

    stages {
        
        stage ('Cleanup'){
            when {
                expression {
                    params.CLEANUP == true
                }
            }
            steps {
                deleteDir()
            }   
        }

        stage ('Git Setup') {
            steps {
                git branch: "${params.BRANCH}",
                url: "https://github.com/kraumar/JenkinsTerraformReccSystemInstances.git"
            }
        }

        stage ('Terraform Init') {

            ansiColor('xterm') {

                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding'
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID'
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){

                    sh ''' #!/bin/bash
                        set -e -o pipefail
                        terraform init -updgrade=true -input=false -reconfigure'''
                }
            }
        }
   }
}
