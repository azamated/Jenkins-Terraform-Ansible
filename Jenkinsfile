pipeline {
    agent any

    environment {
      TF_VAR_aws_access_key = credentials('AWS_ACCESS_KEY_ID')
      TF_VAR_aws_secret_key = credentials('AWS_SECRET_ACCESS_KEY')
      AWS_DEFAULT_REGION = "us-east-2"
      AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
      AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    //Building tool
    tools {
        terraform "TF"
    }

    //Stages begin
    stages {
        stage ('git')   {
            steps {
                git branch: 'main', url: 'https://github.com/azamated/Jenkins-Terraform-Ansible.git'
            }
        }

       stage ('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
       stage ('Terraform Plan and Apply') {
            steps {
                sh "terraform plan"
                sh "terraform apply -auto-approve"
            }
       }
        //Ansible starts here
       stage ('Install Ansible aws modules') {
            steps {
                sh "ansible-galaxy collection install community.aws"
                sh "ansible-galaxy collection install community.general"
            }
       }

       stage ('Initiate playbook') {
            steps {
                ansiblePlaybook disableHostKeyChecking: true, colorized: true, installation: 'Ans', playbook: 'ansible.yml'
            }
       }
    }
}