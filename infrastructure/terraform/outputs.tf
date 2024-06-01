output "instance_ip" {
  value = aws_instance.ec2_todo_list.public_ip
}

output "load_balancer_dns_name" {
  value = aws_lb.lb_todo_list.dns_name
}
