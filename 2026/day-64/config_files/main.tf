provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "day64-vpc"
  }
}

# Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "day64-subnet"
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "day64-ec2"
  }
}

# Resource for S3 bucket import

resource "aws_s3_bucket" "imported" {
  bucket = "terraweek-import-test-sabir"
}

# Resource for re-import S3 bucket

resource "aws_s3_bucket" "logs_bucket" {
  bucket = "terraweek-import-test-sabir"
}
