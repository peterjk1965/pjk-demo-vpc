#set provider "aws" and your location of aws terraform creds
provider "aws" {
  region                   = "us-east-2" # Replace with your desired AWS region
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "terraform"
}
#ubuntu 
resource "aws_instance" "example" {
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  #2 add tags to the instance 
  tags = {
    Name = "terraform-example1"
  }
}
#



