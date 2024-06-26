# For all AWS services: https://developer.hashicorp.com/terraform/tutorials/aws?utm_source=WEBSITE&utm_medium=WEB_IO&utm_offer=ARTICLE_PAGE&utm_content=DOCS

# https://registry.terraform.io/providers/hashicorp/aws/5.52.0/docs/resources/vpc
resource "aws_vpc" "mtc_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true # optional, but may want to specify to be explicit for the team

  tags = {
    Name = "dev"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "mtc_public_subnet" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true # gives our instances a public IP address
  availability_zone       = "us-east-2a"

  tags = {
    Name = "dev-public"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "dev_igw"
  }
}

# NOTE: You can either use a Route resource or define routes inline
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "mtc_public_rt" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "dev_public_rt"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
resource "aws_route" "mtc_route" {
  route_table_id         = aws_route_table.mtc_public_rt.id
  destination_cidr_block = "0.0.0.0/0" # all IP addresses will head for this internet gateway
  gateway_id             = aws_internet_gateway.mtc_internet_gateway.id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
# Bridge the gap between the route table and the subnet
resource "aws_route_table_association" "mtc_public_assoc" {
  subnet_id      = aws_subnet.mtc_public_subnet.id
  route_table_id = aws_route_table.mtc_public_rt.id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "mtc_sg" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.mtc_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # equivalent to all ports/protocols
    cidr_blocks = [var.myip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # equivalent to all ports/protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ssh-keygen -t ed25519 (slightly more secure than rsa)
# /Users/kdunc/.ssh
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
resource "aws_key_pair" "mtc_auth" {
  key_name = "mtc_key"
  public_key = file("~/.ssh/mtckey.pub")
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# ssh -i ~/.ssh/mtckey ubuntu@public-ip-address
resource "aws_instance" "dev_node" {
  instance_type = "t2.micro"
  ami = data.aws_ami.server_ami.id
  key_name = aws_key_pair.mtc_auth.id # can also use aws_key_pair.mtc_auth.key_name
  vpc_security_group_ids = [aws_security_group.mtc_sg.id]
  subnet_id = aws_subnet.mtc_public_subnet.id
  user_data = file("userdata.tpl")

  # to resize the default size on this instance
  root_block_device {
    volume_size = 10 # default is 8
  }

  tags = {
    Name = "dev_node"
  }

  # terraform apply -replace aws_instance.dev_node
  # Provisioner that runs a command (after this deploys?)
  # https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec
  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-config.tpl", {
      sshconfig = "${var.ssh_config}"
      hostname = self.public_ip,
      user = "ubuntu",
      identityfile = "${var.identity_file}"
    })

    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  }
}