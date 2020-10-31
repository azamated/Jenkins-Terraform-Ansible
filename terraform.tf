terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
######################
#Create aws instances#
######################

provider "aws" {
  region = "us-east-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


#Copy a public key to instances
resource "aws_key_pair" "id_rsa" {
  key_name   = "aws_id_rsa_pub"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDNxhmHLltrEARihdLYyZfZSIY4zs04u/8fTaieCkfDIeDN3BPFCwUD6+ahw4AC+YWCXuj0HpR4dR4MyNeRzeLz0EhvRmGPuslAByBs/sNTkb1HaoMxvzOvcPd6hTQGv2VN/RYfq+O5XWR74yY2vOZ+mtsWT2q5syKsIBsQco3K9apLaX03+4X9xAvPjSP0WWi8YBBpZ/rdzQq1pyPO2eKBpq5zF61B1E9D98UfTX82ZPVg7Hrr85YB8Pc+pCPti+9qOLJEBXacZdt43KMwYnR+XbZHG25qS/o+wDsf1j2GzUfgGA9yIq+ZNrBFMJDrGBCvZbxlg4d3DhVcfrAxY7eW5DqyqXSjY+NGQbhlL8bBdXS+a/X0iLAwNPU4tv9vNg+XMk6lL6JhJDyn3Ri9qKzU5W0EIrHeHZbk1PEnUzW1XEIxjD1Jg4qcwvQVvJVjXfCrwJPimPTCfd3RgjEhyoA0liAnPgrQw6+46f1EfrR4n7swhfhmJIyphZo9bWxNfyM= root@devops"
}

resource "aws_instance" "builder" {
  ami = "ami-07efac79022b86107"
  instance_type = "t2.micro"
  monitoring = true
  key_name = "aws_id_rsa_pub"
  vpc_security_group_ids = ["${aws_security_group.build_allow_ssh.id}"]

}

resource "aws_instance" "production" {
  ami = "ami-07efac79022b86107"
  instance_type = "t2.micro"
  monitoring = true
  key_name = "aws_id_rsa_pub"
  vpc_security_group_ids = ["${aws_security_group.prod_allow_ssh_web.id}"]


}

##############################################
#Create security groups with FW ports allowed#
##############################################

resource "aws_security_group" "build_allow_ssh" {
  name = "allow_ssh"
  description = "Allow SSH inbound traffic"
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "prod_allow_ssh_web" {
  name = "allow_ssh_web"
  description = "Allow SSH and Web inbound traffic"
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

