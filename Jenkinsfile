pipeline {
    agent any

    environment {
      TF_VAR_aws_secret_key = credentials('AWS_ACCESS_KEY_ID')
      TF_VAR_aws_access_key = credentials('AWS_SECRET_ACCESS_KEY')
    }

    //Building tool
    tools {
        terraform "TF"
        //ansible "Ans"
    }

    //Stages begin
    stages {
        stage ('git')   {
            steps {
                //git 'https://github.com/azamated/Jenkins-Terraform-Ansible.git'
                sh "wget "
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
         //Ansible start here
       stage ('Initiate playbook') {
            steps {
                sh "ansible-playbook ansible.yml"
            }
       }
    }
}