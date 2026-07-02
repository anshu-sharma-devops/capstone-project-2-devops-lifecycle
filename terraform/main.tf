provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "capstone_sg" {
  name        = "capstone-2-devops-sg"
  description = "Security group for Capstone 2"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
  from_port = 2379
  to_port = 2380
  protocol = "tcp"
  self = true
}

ingress {
  from_port = 10257
  to_port = 10257
  protocol = "tcp"
  self = true
}

ingress {
  from_port = 10259
  to_port = 10259
  protocol = "tcp"
  self = true
}

ingress {
  from_port = 179
  to_port = 179
  protocol = "tcp"
  self = true
}

ingress {
  from_port = 4789
  to_port = 4789
  protocol = "udp"
  self = true
}
  ingress {
    from_port   = 30008
    to_port     = 30008
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  instances = {
    worker1-jenkins = "Jenkins-Java"
    worker2-k8s     = "Docker-Kubernetes"
    worker3-master  = "Java-Docker-Kubernetes"
    worker4-k8s     = "Docker-Kubernetes"
  }
}

resource "aws_instance" "workers" {
  for_each = local.instances

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.capstone_sg.id]

  tags = {
    Name = each.key
    Role = each.value
  }
}
