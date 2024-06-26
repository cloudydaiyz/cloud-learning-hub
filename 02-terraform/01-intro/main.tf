# Provider block
provider "aws" {
    profile = "kduncan"
    region = "us-east-2"
}

# Resources block
# https://registry.terraform.io/providers/hashicorp/aws/5.52.0/docs/resources/instance
resource "aws_instance" "app_server" {
    ami = "ami-07d7e3e669718ab45" # Amazon Linux 2023
    instance_type = var.ec2_instance_type

    tags = {
        Name = var.instance_name
    }
}