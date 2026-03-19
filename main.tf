provider "aws" {
  region = "us-west-2"
}

# Key Pair
resource "aws_key_pair" "my_key" {
  key_name   = "terraform-key"
  public_key = var.public_key
}

# Security Group
resource "aws_security_group" "my_sg" {
  name = "allow_ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "my_ec2" {
  ami           = "ami-02a7598d8a6d8424f"
  instance_type = "t2.micro"

  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.my_sg.id]

user_data = <<-EOF
#!/bin/bash
yum update -y
yum install -y epel-release
yum install -y nginx
systemctl start nginx
systemctl enable nginx
EOF

  tags = {
    Name = "bheemtfec2"
  }
}
