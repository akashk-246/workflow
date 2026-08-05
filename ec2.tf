#1.vpc

resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name       = "${var.customer}-vpc"
    Managed_by = var.managed_by
  }
}

#2.Internet gateway

resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name       = "${var.customer}-igw1"
    Managed_by = var.managed_by
  }
}

# 3.Pub Subnet
resource "aws_subnet" "pub_sub1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name       = "${var.customer}-pub_sub1"
    Managed_by = var.managed_by
  }
}

# 4.Pri Subnet

resource "aws_subnet" "pri_sub1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name       = "${var.customer}-pri_sub1"
    Managed_by = var.managed_by
  }
}

#5. Public RT

resource "aws_route_table" "pub_rt1" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw1.id
  }

  tags = {
    Name       = "${var.customer}-pub_rt1"
    Managed_by = var.managed_by
  }
}

#6. Private RT

resource "aws_route_table" "pri_rt1" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name       = "${var.customer}-pri_rt1"
    Managed_by = var.managed_by
  }
}

#7.Pub Subnet association

resource "aws_route_table_association" "pubsubnet_rt1" {
  subnet_id      = aws_subnet.pub_sub1.id
  route_table_id = aws_route_table.pub_rt1.id
}

#8.Pri Subnet association

resource "aws_route_table_association" "prisubnet_rt1" {
  subnet_id      = aws_subnet.pri_sub1.id
  route_table_id = aws_route_table.pri_rt1.id
}

#9. Security Group1

resource "aws_security_group" "sg1" {
  name = "${var.customer}-sg1"
  #description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id = aws_vpc.vpc1.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["202.83.17.138/32", aws_vpc.vpc1.cidr_block]
  }

  ingress {
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
    Name       = "${var.customer}-sg1"
    Managed_by = var.managed_by
  }
}

#10. EC2 web1
resource "aws_instance" "web1" {
  ami                         = var.Ami_id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.pub_sub1.id
  key_name                    = "demo-key"
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [aws_security_group.sg1.id]


  tags = {
    Name       = "${var.customer}-web1"
    Managed_by = var.managed_by
  }
}

# #11. EC2 DB1
resource "aws_instance" "db1" {
  ami           = var.Ami_id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.pri_sub1.id
  key_name = "demo-key"
  vpc_security_group_ids = [aws_security_group.sg1.id]


  tags = {
    Name = "${var.customer}-db1"
    Managed_by = var.managed_by
  }
}

