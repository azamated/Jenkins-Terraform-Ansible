terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

variable "aws_access_key" {
  type = "string"
}
variable "aws_secret_key" {
  type = "string"
}


######################
#Create aws instances#
######################
provider "aws" {
  region = "us-east-2"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}


#Copy a public key to instances
resource "aws_key_pair" "id_rsa" {
  key_name   = "aws_id_rsa_pub"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDha4tKrImw/ij1qy5obpegrTFHSwuRAZky1gSGii0Fh1D3Wtu4EoPOLqrfyDy9VzwSkhVdd9iXJAw1QMFM490s+dN0nwVopArTUfC+gp+b31q3fOL6FnCcF7mU2S8giHElqTOsWlvGu+P/CgiwZlL0Xx/glK40DApJ+pb2do7DJsOjsPA+y3qiIlNGK68u3Qu0DCFBIIQ1QgAl/fCNeuFLVtE2Xg2fOxFIl3n0INSnFK4jvyLZ/24usH1nJVC2cST93WwEGLijdbuAk+w5mKPJCjHAb8MH2Jgqyv2Tsgb8al5FQCnc4lzPtraf1GCMcX02RDC3d7yFBRxrmQxFWcHvcGT3K+f+SRMssll5QJbC+G5VKNDeb8ZpTx/BJ1G6Fj5gTLPoRf83RMiY8TGdQoZig8qdvb3SAGb3KMygr5LUhx/O4B4fK1SUpnhvSZ8I8WSTtJAtBfIVJU9AXYK5Pcbm4DOvOC//1JCL8Lx2g4jnsfP91+bJqxL2/D1Y1xQAPUk= root@devops"
}

resource "aws_instance" "builder12" {
  ami = "ami-07efac79022b86107"
  instance_type = "t2.micro"
  monitoring = true
  key_name = "aws_id_rsa_pub"
  vpc_security_group_ids = ["${aws_security_group.build_allow_ssh.id}"]
  tags = {
    Name = "app_build"
  }
}

resource "aws_instance" "production12" {
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

