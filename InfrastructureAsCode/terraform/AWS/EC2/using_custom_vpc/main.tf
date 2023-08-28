provider "aws" {
  region = "us-east-1"
}

# create custom vpc
resource "aws_vpc" "lab" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Lab-VPC"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.lab.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.lab.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Public Subnet 2"
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.lab.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private Subnet 1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.lab.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private Subnet 2"
  }
}

resource "aws_internet_gateway" "labgw" {
 vpc_id = aws_vpc.lab.id
 
 tags = {
   Name = "LAB IG"
 }
}

resource "aws_route_table" "labrt" {
 vpc_id = aws_vpc.lab.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.labgw.id
 }
 
 tags = {
   Name = "Lab Route Table"
 }
}

resource "aws_route_table_association" "public_subnet1_assoc" {
 subnet_id      = aws_subnet.public_subnet1.id
 route_table_id = aws_route_table.labrt.id
}

resource "aws_route_table_association" "public_subnet2_assoc" {
 subnet_id      = aws_subnet.public_subnet2.id
 route_table_id = aws_route_table.labrt.id
}

resource "aws_security_group" "webserversg2" {
  name        = "Web-Server2-SG"
  description = "Allows HTTP access"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description = "Allow web access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-Server2-SG"
  }
}

data "aws_ami" "amazon-linux-2" {
 most_recent = true
 owners = [ "amazon" ]
 filter {
   name   = "name"
   values = [ "amzn2-ami-hvm-*-gp2" ]
 }
}
resource "aws_instance" "Web-Server2" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet1.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.webserversg2.id]
  tags = {
    Name = "Web-Server2"
  }
  iam_instance_profile = "Work-Role"
  user_data = <<EOF
  #!/bin/bash
  # Install Apache Web Server and PHP
  yum install -y httpd mysql
  amazon-linux-extras install -y php7.2
  # Download Lab files
  wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-EDNETW-1-60961/1-lab-getting-started-vpc/s3/inventory-app.zip
  unzip inventory-app.zip -d /var/www/html/
  # Download and install the AWS SDK for PHP
  wget https://github.com/aws/aws-sdk-php/releases/download/3.62.3/aws.zip
  unzip aws -d /var/www/html
  # Turn on web server
  chkconfig httpd on
  service httpd start
  EOF
}