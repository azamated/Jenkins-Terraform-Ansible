pipeline {
    agent any

    //Building tool
    tools {
        terraform "TF"
    }

    //Stages begin
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