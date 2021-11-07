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
                            terraform plan -out=terraform_plan.out'''
                    }
                }
            }   
        }

        stage ('Approve Terraform changes'){
            when {
                expression {
                    params.BRANCH == 'master' && fileExists('terraform_plan.out')
                }
            }
            steps{
                script{
                    timeout(time: 5, unit: 'MINUTES'){
                        input(message: "Validate and approve your changes:", ok: 'Apply')
                    }
                }
            }
        }

        stage ('Apply Terraform changes'){
            when {
                expression {
                    params.BRANCH == 'master' && fileExists('terraform_plan.out')
                }
            }
            steps{
                ansiColor('xterm'){
                     withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: params.CREDENTIALS,
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]){
                        sh ''' #!/bin/bash
                            # 0 - no change
                            # 1 - errors
                            # 2- changes
                            terraform apply -input=false terraform_plan.out'''
                     }
                }
            }
        }


   }
}
