data "aws_vpc" "vpc_id" {
  id = "vpc-074236cf5217078f1"
}

data "aws_subnet" "subnet_us_east_1a" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc_id.id]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a"]
  }
}

data "aws_subnet" "subnet_us_east_1b" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc_id.id]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1b"]
  }
}


resource "aws_security_group" "sg_todo_list" {
  name        = "sg_todo_list"
  description = "Grupo de seguridad para la aplicacion Todo List"
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

  ingress {
    description = "Grafana"
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Prometheus"
    from_port   = 9090
    to_port     = 9090
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

# Crea un Application Load Balancer (ALB)
resource "aws_lb" "lb_todo_list" {
  name               = "todo-list-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_todo_list.id]  # Reemplaza con tu security group ID
  subnets            = [
    data.aws_subnet.subnet_us_east_1a.id,
    data.aws_subnet.subnet_us_east_1b.id
  ]  
  enable_deletion_protection = false
}

# Crea un Target Group
resource "aws_lb_target_group" "tg_todo_list" {
  name     = "tg-todo-list"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc_id.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "tg_grafana" {
  name     = "tg-grafana"
  port     = 3001
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc_id.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "tg_prometheus" {
  name     = "tg-prometheus"
  port     = 9090
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc_id.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb_todo_list.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_todo_list.arn
  }
}

resource "aws_lb_listener" "http_grafana" {
  load_balancer_arn = aws_lb.lb_todo_list.arn
  port              = 3001
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg_grafana.arn
  }
}

resource "aws_lb_listener" "http_prometheus" {
  load_balancer_arn = aws_lb.lb_todo_list.arn
  port              = 9090
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg_prometheus.arn
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment_miapp" {
  target_group_arn = aws_lb_target_group.tg_todo_list.arn
  target_id        = aws_instance.ec2_todo_list.id
  port             = 3000
}

resource "aws_lb_target_group_attachment" "tg_attachment_grafana" {
  target_group_arn = aws_lb_target_group.tg_grafana.arn
  target_id        = aws_instance.ec2_todo_list.id
  port             = 3001
}

resource "aws_lb_target_group_attachment" "tg_attachment_prometheus" {
  target_group_arn = aws_lb_target_group.tg_prometheus.arn
  target_id        = aws_instance.ec2_todo_list.id
  port             = 9090
}

resource "aws_instance" "ec2_todo_list" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.sg_todo_list.id]
  subnet_id              = data.aws_subnet.subnet_us_east_1a.id
  
  tags = {
    Name = "My-EC2-Todo-List"
  }

  user_data = file("script.sh")
}
