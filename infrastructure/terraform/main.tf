data "aws_vpc" "vpc_id" {
  id = "vpc-074236cf5217078f1"
}

data "aws_subnet" "subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc_id.id]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a"]
  }
}


resource "aws_security_group" "sg_todo_list" {
  name        = "sg_todo_list"
  description = "Grupo de seguridad para la aplicación 'Todo List'"
  vpc_id      = data.aws_vpc.vpc_id.id

  // Reglas de ingreso
  ingress {
    description      = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::0/0"]
  }

  ingress {
    description      = "API"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::0/0"]
  }

  # ingress {
  #   description      = "Database from Amazon"
  #   from_port        = 3306
  #   to_port          = 3306
  #   protocol         = "tcp"
  #   cidr_blocks      = ["0.0.0.0/0"]
  #   ipv6_cidr_blocks = ["::0/0"]
  # }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Reglas de egreso
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "My-sg-todo-list"
  }
}

resource "aws_instance" "ec2_todo_list" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.sg_todo_list.id]
  subnet_id              = data.aws_subnet.subnet.id
  
  tags = {
    Name = "My-EC2-Todo-List"
  }

  user_data = file("script.sh")
}
