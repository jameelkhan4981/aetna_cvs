provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-085ad6ae776d8f09c" # Amazon Linux 2
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-example"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              curl -sL https://rpm.nodesource.com/setup_14.x | bash -
              yum install -y nodejs
              yum install -y git
              git clone https://github.com/YOUR_GITHUB_USERNAME/sample-node-app.git
              cd sample-node-app
              npm install
              npm start
              EOF
}
