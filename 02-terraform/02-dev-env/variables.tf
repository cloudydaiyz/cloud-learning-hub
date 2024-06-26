# Declares variables that will be used throughout config

variable "myip" {
  description = "Your IP address"
  type = string
}

variable "host_os" {
  description = "Host operating system"
  type = string
  default = "mac"
}

variable "identity_file" {
  description = "SSH identity file for your public key"
  type = string
  default = "~/.ssh/mtckey"
}

variable "ssh_config" {
  description = "SSH config file"
  type = string
  default = "~/.ssh/config"
}