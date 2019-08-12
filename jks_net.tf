resource "aws_vpc" "jks-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Contact = var.contact, Project = var.projet }
}

resource "aws_subnet" "jks-subnet" {
  vpc_id                  = "${aws_vpc.jks-vpc.id}"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = { Contact = var.contact, Project = var.projet }
}

resource "aws_internet_gateway" "jks-gw" {
  vpc_id = "${aws_vpc.jks-vpc.id}"
  tags = { Contact = var.contact, Project = var.projet }
}

resource "aws_route_table" "jks-rtb" {
  vpc_id = "${aws_vpc.jks-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.jks-gw.id}"
  }
  tags = { Contact = var.contact, Project = var.projet }
}

resource "aws_route_table_association" "jks-ass" {
  subnet_id      = "${aws_subnet.jks-subnet.id}"
  route_table_id = "${aws_route_table.jks-rtb.id}"
}

resource "aws_security_group" "mst-sg" {
  name = "mst_sg"
  vpc_id      = "${aws_vpc.jks-vpc.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    ## cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["${var.ip_perso}/32"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    ## cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["${var.ip_perso}/32"]
  }
  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Contact = var.contact, Project = var.projet }
}

resource "aws_security_group" "wrk-sg" {
  name = "wrk_sg"
  vpc_id      = "${aws_vpc.jks-vpc.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    ## cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["${var.ip_perso}/32"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    ## cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["${aws_instance.jks-mst.private_ip}/32"]
  }
  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Contact = var.contact, Project = var.projet }
}
