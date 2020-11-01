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
variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}


provider "aws" {
  region = "us-east-2"
  access_key = "$aws_access_key"
  secret_key = "$aws_secret_key"
}


#Copy a public key to instances
resource "aws_key_pair" "id_rsa" {
  key_name   = "aws_id_rsa_pub"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCmmh41bXYpmSmrfRZAFpUs2yvZ5dEK1juSbOdCFv79RcKz6K3ktqzFgAE/8CHz75G7epNTSzcGD5DxYxKCbOhdEOV0nXkVmYYc0PfMZ+Ii1GRcLqYUHi0gHdZ6z8Mf2YIzzWRlddiO0Zu84b4Hk8JLuvL6qZBp+bTH83M92LBw2ZCIlhZGvkoLtil/C2hLvAoEgTRS3uK31S+FLCAorZ2ZMzEGwt/3bQV8N6vUo8ElqHNL0sbPECgUFKuZb5rrEMK0cl/6dhI+NhTFAMpPcJBHwcM7Tyle2Hby8nqXgv/zRpfo0XgCWCQMSlPgtVH/hUNnIuLr6Tp1sobnjpeceEEV root@devops1"
}

resource "aws_instance" "builder" {
  ami = "ami-07efac79022b86107"
  instance_type = "t2.micro"
  monitoring = true
  key_name = "aws_id_rsa_pub"
  vpc_security_group_ids = ["${aws_security_group.build_allow_ssh.id}"]
  tags = {
    Name = "app_build"
  }
}

resource "aws_instance" "production" {
  ami = "ami-07efac79022b86107"
  instance_type = "t2.micro"
  monitoring = true
  key_name = "aws_id_rsa_pub"
  vpc_security_group_ids = ["${aws_security_group.prod_allow_ssh_web.id}"]
  tags = {
    Name = "app_prod"
  }

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

