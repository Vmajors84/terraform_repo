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


resource "aws_instance" "MyEC2webserver" {
  ami           = "ami-0d3183af565a0a95d"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}
