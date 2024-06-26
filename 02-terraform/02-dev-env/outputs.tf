output "dev_node_public_ip" {
    description = "IP address of the dev node"
    value = aws_instance.dev_node.public_ip
}