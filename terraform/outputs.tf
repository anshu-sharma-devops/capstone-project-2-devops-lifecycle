output "instance_public_ips" {
  value = {
    for name, instance in aws_instance.workers :
    name => instance.public_ip
  }
}

output "ssh_commands" {
  value = {
    for name, instance in aws_instance.workers :
    name => "ssh -i ~/Downloads/jenkins-key.pem ubuntu@${instance.public_ip}"
  }
}