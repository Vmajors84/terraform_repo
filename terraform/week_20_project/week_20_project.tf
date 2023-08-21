terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "project_15" {
  bucket = "my-tf-pj15-bucket"
  acl = "private"

  tags = {
    Name        = "project_15_bucket"
    Environment = "Dev"
  }
}

resource "aws_key_pair" "ssh_login" {
  key_name   = "id_rsa"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDoC+ewt3Ommrm3oQl2FnLQU+6NONiquB7o8dlHCG0ZVJzzv5t76dJ8Kcj7cRCQjOlEzViKCfIhJt7UiTQj7q8cHPJ5oojJxEsVwdglOCDQMYOQGZUTn5FTzBNHBv+8F1STzJKaC0a57hew4T5m8RhhX8Tn/3bbqa94kE2AjdKxJQYZ8Uie93m7w7gjNwWIALAKjZUJbQBFC6NPrpX1FlLtk9EDIixR/4PavCac6u4Y+y+pnRuNWrQNxY9cWe75WJGOXlHGM8lXRp0WglO5tuo7Tlir/NRa5woUI2CHrGY+E/rbaJQ8n84H47yK//D7WU13DzrR2LdLDuZ3fTv9e+Tay2+4/2l7T+hVXK3FVwxkEQiVzprPh6Q4axTbB2qLPz1EnKzDgVp4++LVc6ryH7hjvzHUWMWwCGyagr8WFqgAZVR1pUo02NH0W5hZojhlCmXRDu/PFRmFugBZRsP6C7Lkt6WNkqY3zUEGcoCoCDlpFlecmkoI6/Riz9VYSbw9N9M= redsl@DESKTOP-EFVCHK"
}

resource "aws_instance" "terraform_jenkins" {
  ami           = "ami-024e6efaf93d85776"
  instance_type = "t2.micro"
  key_name      = "id_rsa"
  count         = 1
  vpc_security_group_ids = [
    "sg-09e8530545e34d1ca"
  ]
  user_data = <<EOF
#!/bin/bash

sudo apt install openjdk-11-jre
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y
sudo systemctl enable jenkins -y
sudo systemctl start jenkins
EOF

  tags = {
    Name = "jenkins_terraform"
  }
}

