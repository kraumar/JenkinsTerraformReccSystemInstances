pipeline {
    agent any

    parameters {
        string(name: 'BRANCH', defaultValue: params.BRANCH ?: 'master', description: 'branch to use')
        string(name: 'CREDENTIALS', defaultValue: params.CREDENTIALS ?: 'credentials', description: 'aws credentials to use')
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
                print params.CREDENTIALS
            }
        }

        stage ('Terraform Init') {
            steps{
                ansiColor('xterm') {

                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: params.CREDENTIALS,
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]){

                        sh ''' #!/bin/bash
                            set -o pipefail
                            terraform init -upgrade=true -input=false -reconfigure'''
                    }
                }
            }   
        }

        stage ('Terraform Plan'){
            steps{
                ansiColor('xterm') {

                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: params.CREDENTIALS,
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]){

                        sh ''' #!/bin/bash
                            # 0 - no change
                            # 1 - errors
                            # 2 - changes
                            terraform plan -input=false -detailed-exitcode -out=terraform_plan.out > terraform-output.log

                            CODE=${?}
                            if [ ${CODE} = "0" ]
                                then
                                cat terraform-output.log
                                exit 0
                            elif [ ${CODE} = "2"]
                                then
                                cat terraform-output.log
                                exit 0
                            fi

                            exit ${CODE}'''
                    }
                }
            }   
        }
   }
}
