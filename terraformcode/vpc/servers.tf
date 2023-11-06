provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAYHGKTOPMVF3AUX5Q"
  secret_key = "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"
}

resource "aws_instance" "demo_server" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  key_name      = "dpw"
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  subnet_id     = aws_subnet.dpp-public_subnet_01.id

  for_each = toset(["jenkins-master", "build-slave", "ansible"])

  tags = {
    Name = each.key
  }
}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "SSH and Jenkins Access"
  vpc_id      = aws_vpc.dpp-vpc.id

  ingress {
    description = "SSH port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins port"
    from_port   = 8080
    to_port     = 8080
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
    Name = "SSH and Jenkins Access"
  }
}

resource "aws_vpc" "dpp-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "dpp-vpc"
  }
}

resource "aws_subnet" "dpp-public_subnet_01" {
  vpc_id                  = aws_vpc.dpp-vpc.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "dpp-public_subnet_01"
  }
}

resource "aws_internet_gateway" "dpp-igw" {
  vpc_id = aws_vpc.dpp-vpc.id
  tags = {
    Name = "dpp-igw"
  }
}

resource "aws_route_table" "dpp-public-rt" {
  vpc_id = aws_vpc.dpp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dpp-igw.id
  }

  tags = {
    Name = "dpp-public-rt"
  }
}

resource "aws_route_table_association" "dpp-rta-public-subnet-1" {
  subnet_id      = aws_subnet.dpp-public_subnet_01.id
  route_table_id = aws_route_table.dpp-public-rt.id
}

module "sgs" {
  source = "../sg_eks"
  vpc_id  = aws_vpc.dpp-vpc.id
}

module "eks" {
  source     = "../eks"
  vpc_id     = aws_vpc.dpp-vpc.id
  subnet_ids = [aws_subnet.dpp-public_subnet_01.id, aws_subnet.dpp-public_subnet_02.id]
  sg_ids     = module.sgs.security_group_public
}
