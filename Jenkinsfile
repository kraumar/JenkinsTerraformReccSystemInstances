pipeline {
    agent any

    parameters {
        string(name: 'BRANCH', defaultValue: params.BRANCH ?: 'master', description: 'branch to use')
        string(name: 'AWS CREDENTIALS', defaultValue: params.CREDENTIALS ?: 'credentials', description: 'aws credentials to use')
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
            steps{
                ansiColor('xterm') {

                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
                        credentialsId: params.CREDENTIALS]]){

                        sh ''' #!/bin/bash
                            set -o pipefail
                            terraform init -updgrade=true -input=false -reconfigure'''
                    }
                }
            }   
        }
   }
}
