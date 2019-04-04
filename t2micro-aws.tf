provider "aws" {
  access_key = "AKIA3JDLJD2E2VV6QAOY"
  secret_key = "0DbIqVZwPFmItSJeaxAi5sXYWnRf8n9f7HowK8iD"
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}