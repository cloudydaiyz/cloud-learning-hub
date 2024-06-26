# NOTE: Look up information for a specific AMI by going to AWS Console > EC2 > AMIs
# and enter the AMI ID (you can find by trying to launch an instance and browsing
# the AMI marketplace)
data "aws_ami" "server_ami" {
    most_recent = true
    owners = ["099720109477"]

    filter {
        name = "name"

        # use an astericks instead of the date to select any date
        values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    }
}