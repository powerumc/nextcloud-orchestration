data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.nextcloud.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "next-cloud vpc"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.nextcloud.subnet_cidr_block
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "next-cloud subnet1"
  }
  depends_on = [aws_vpc.vpc]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "next-cloud igw"
  }
  depends_on = [aws_vpc.vpc]
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "next-cloud rtb"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "rt" {
  route_table_id         = aws_route_table.rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "subnet1_rta" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_security_group" "sg" {
  name        = "next-cloud sg"
  description = "next-cloud sg"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
    description = "next-cloud ssh"
  }
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
    description = "next-cloud http"
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
    description = "next-cloud https"
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "next-cloud sg"
  }
}

resource "aws_network_interface" "eni" {
  subnet_id       = aws_subnet.subnet1.id
  security_groups = [aws_security_group.sg.id]
  private_ips     = [var.nextcloud.instance_private_ip]
  tags = {
    Name = "next-cloud eni"
  }
}

resource "aws_eip" "eip" {
  vpc                       = true
  network_interface         = aws_network_interface.eni.id
  associate_with_private_ip = var.nextcloud.instance_private_ip
  tags = {
    Name = "next-cloud eip"
  }
}

resource "aws_instance" "web" {
  ami           = var.nextcloud.instance_ami
  instance_type = var.nextcloud.instance_type
  key_name      = var.nextcloud.instance_key_name
  network_interface {
    network_interface_id = aws_network_interface.eni.id
    device_index         = 0
  }
  tags = {
    Name = "next-cloud web"
  }
}

resource "aws_ebs_volume" "ebs" {
  type              = var.nextcloud.ebs_db_volumn_type
  size              = var.nextcloud.ebs_db_volumn_size
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "next-cloud ebs"
  }
}

resource "aws_volume_attachment" "ebs_attachment" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.ebs.id
  instance_id = aws_instance.web.id
}

data "aws_route53_zone" "zone" {
  name = var.nextcloud.route53_domain
}

resource "aws_route53_record" "domain_record" {
  count   = var.nextcloud.route53_domain != "" && var.nextcloud.your_nextcloud_domain != "" ? 1 : 0
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.nextcloud.your_nextcloud_domain
  type    = "A"
  ttl     = 300
  records = [aws_eip.eip.public_ip]
}
