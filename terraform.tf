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
  //access_key = var.aws_access_key
  //secret_key = var.aws_secret_key
}


#Copy a public key to instances
resource "aws_key_pair" "id_rsa" {
  key_name   = "aws_id_rsa_pub"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDA2FLShQXuivwKUxqB+Rm5SSOSZ+DBZ5E/PP83vSokp/p/Q9zodpNUv3S2cOW/nypQfKHKXjCqZ7Zn2gatkheCtFFeYpUQohmKmzpdUb1uSLFax6Fsa7Wkx6MFMRxgWz0hNpFEgpUxEMcJADBkRMJ5pgxzVSE5yP2p5mOxd5pXXToVRRLZPv2LhxklnsXcdVUvzYhBGj/dDD9yi2nB+e7y87AV/MXYhtwMIvyl2qDkC2EgAOw3612MCCNA43wO9PFQkfgFx73RLsrKiZKQsJzU7ds4B/4kaanF3SEz1SpN+2BMhonOL1AO6cngTCTrRQKwDYaWB4jElgBQTqeGvut5 jenkins@039cd1d9c2e8"
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

