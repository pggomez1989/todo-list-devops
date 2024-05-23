variable "aws_region" {
  type = string
  default = "us-east-1"  // Norte de Virginia
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "ami" {
  type = string
  default = "ami-04b70fa74e45c3917"  // Canonical, Ubuntu, 24.04 LTS, amd64 noble image build on 2024-04-23
}

variable "key_name" {
  type = string
  default = "my-key-api"
}