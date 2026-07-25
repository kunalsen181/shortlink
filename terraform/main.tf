data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "shortlink-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet_cidr

  map_public_ip_on_launch = true

  tags = {
    Name = "shortlink-public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "shortlink-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "shortlink-public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id

  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ec2_sg" {

  name = "shortlink-sg"

  description = "Security group for ShortLink"

  vpc_id = aws_vpc.main.id

  ingress {

    description = "SSH"

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    description = "HTTP"

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    description = "HTTPS"

    from_port = 443

    to_port = 443

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    description = "Jenkins"

    from_port = 8080

    to_port = 8080

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    description = "Grafana"

    from_port = 32000

    to_port = 32000

    protocol = "tcp"

    cidr_blocks= ["0.0.0.0/0"]

  }

  ingress {

    description = "Prometheus"

    from_port = 32090

    to_port = 32090

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }


  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {

    Name = "shortlink-security-group"

  }

}

resource "aws_key_pair" "shortlink_key" {
  key_name   = "shortlink-key"
  public_key = file("${path.module}/ssh/shortlink-key.pub")

  tags = {
    Name = "shortlink-key"
  }
}

resource "aws_instance" "shortlink_server" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = "c7i-flex.large"

  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  key_name = aws_key_pair.shortlink_key.key_name

  associate_public_ip_address = true

  tags = {
    Name = "shortlink-server"
  }
}

resource "local_file" "ansible_inventory" {

  content = templatefile("${path.module}/inventory.tpl", {
    public_ip = aws_instance.shortlink_server.public_ip
  })

  filename = "${path.module}/../ansible/inventory/aws.ini"

}
