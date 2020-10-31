pipeline {
    agent any

    tools {
        terraform "TF"
    }

  //  environment {
   //    ACCESS_KEY = credentials('AWS_ACCESS_KEY_ID')
  //     SECRET_KEY = credentials('AWS_SECRET_ACCESS_KEY')
   //}

    stages {
        stage ('git')   {
            steps {
                git 'https://github.com/azamated/Jenkins-Terraform-Ansible.git'
            }
        }

        stage ('Terraform init and Apply') {
            steps {
                sh 'terraform init'
                sh "terraform plan"
                sh "terraform apply -auto-approve"
            }

        }
    }

}