provider "aws" {
  access_key = "AKIAJ75UT3AKG424JNSQ"
  secret_key = "rzLChlyYTRcpCYMVQEjR1A0Uc4kUnkiPdlEI6p62"
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}