pipeline {
    agent any

    environment {
      TF_VAR_aws_access_key = credentials('AWS_ACCESS_KEY_ID')
      TF_VAR_aws_secret_key = credentials('AWS_SECRET_ACCESS_KEY')
    }

    //Building tool
    tools {
        terraform "TF"
    }

    //Stages begin
    stages {
        /*stage ('git')   {
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
       /*stage ('Initiate playbook') {
            steps {
                sh "sleep 1m"
                sh "ansible-playbook ansible.yml"
            }
       }*/
       stage ('Initiate playbook') {
            steps {
                ansiblePlaybook colorized: true, credentialsId: '4a40fc62-80e4-4891-b252-7e5a7fe4f3ce', installation: 'Ans', playbook: 'ansible.yml'
            }
       }


    }
}