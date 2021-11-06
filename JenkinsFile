pipeline {
    agent any

    parameters {
        string(name: 'BRANCH', defaultValue: params.BRANCH ?: 'master', description: 'branch to use')
        string(name: 'CREDENTIALS', defaultValue: params.CREDENTIALS ?: 'credentials', description: 'aws credentials')
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
  }
}
