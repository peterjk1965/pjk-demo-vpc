#set provider "aws" and your location of aws terraform creds
provider "aws" {
  region                   = "us-east-2" # Replace with your desired AWS region
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "terraform"
}
#ubuntu 
resource "aws_instance" "example" {
  ami           = "ami-0323b157afd11740f"
  instance_type = "t2.micro"
  key_name      = "ohio"
  #4 add security group here
  vpc_security_group_ids = [
    aws_security_group.instance.id
  ]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hey there!" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  #2 add tags to the instance 
  tags = {
    Name = "terraform-example"
  }
}
#3 create a security group
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.59.187.250/32"]
  }
}


#4.5 ad hock added outputs section to see instance ID and Public IP
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.example.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.example.public_ip
}

