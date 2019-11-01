variable "vpc_somos"{
  default = "vpc-9c427df8"
}

provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

resource "aws_security_group" "sg-monitoring-test" {
  name        = "Monitoring"
  description = "Monitoring Test"
  vpc_id      = "${var.vpc_somos}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["10.63.116.0/24"]
  }

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    cidr_blocks     = ["10.63.116.0/24"]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["10.63.116.0/24"]
  }

  ingress {
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    cidr_blocks     = ["10.63.116.0/24"]
  }

  ingress {
    from_port       = 9093
    to_port         = 9093
    protocol        = "tcp"
    cidr_blocks     = ["10.63.116.0/24"]
  }

  ingress {
    from_port       = 9115
    to_port         = 9115
    protocol        = "tcp"
    cidr_blocks     = ["10.63.116.0/24"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "monitoring-test" {
  ami                         = "ami-04b9e92b5572fa0d1"
  instance_type               = "t3.small"
  key_name                    = "devops-adm-virginia"
  subnet_id                   = "subnet-6912ae43"
  associate_public_ip_address = true
  security_groups             = ["${aws_security_group.sg-monitoring-test.id}"]

  user_data     = <<SCRIPT
#!/bin/bash
echo "INSTALL DOCKER"
curl -fsSL https://get.docker.com/ | bash
usermod -aG docker ubuntu
echo "INSTALL DOCKER-COMPOSE"
curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
echo "CLONE REPO"
cd /root && git clone https://github.com/alessanderviana/giropops-monitoring.git
echo "UPDATE O.S."
apt-get update && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -o Dpkg::Options::="--force-confdef"
SCRIPT

tags = {
  Name        = "Monitoring Test"
  Owner       = "SETS"
  Application = "Prometheus, Blackbox, Alert manager, Grafana"
  Environment = "Test"
}

}
