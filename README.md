Task: Write a Jenkins pipeline that builds and deploys a Java web application on AWS instances. One instance shall build a Java web application, and another one shall host a production artifact.

Content:
 - Jenkinsfile -- Jenkins pipeline file
 - terraform.tf -- Terraform config file
 - ansible.yml -- Ansible conf file
 - commands -- useful commands for the project
 - Readme.md

General Requirements:
- Terraform and Ansible must be used in the pipeline
- Instances shall run Docker containers

Prerequisites:
- Jenkins: Java JDK
- Ansible: Python, Boto, botocore, docker-py, community.aws (ansible galaxy collection)
- AWS: IAM user with API and CLI access, ECR repository
- A project with all configuration file shall be hosted in GitHub in a separate repo.
- A Java project is hosted in GitHub ain a separate repo.

Steps:

1. Install Jenkins on DevOps admin machine: 

2. In Jenkins, install the Terraform plugin found in the Jenkins plugin market.

3. Create AWS user and note access key and access secret.

4. Create a new "secret file" credentials in Jenkins with id:
       - AWS_ACCESS_KEY_ID
       - AWS_SECRET_ACCESS_KEY
       
5. Configure Jenkins and Ansible plugins as tools.

6. Create a pipeline job with Jenkinsfile

7. Run the job and enjoy.

