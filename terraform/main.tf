terraform {
  required_version = ">= 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "acceso" {
  key_name   = "${var.nombre_proyecto}-key"
  public_key = file(pathexpand(var.ruta_clave_publica))
}

resource "aws_instance" "app" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.tipo_instancia
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [module.sg.security_group_id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.acceso.key_name

  tags = {
    Name     = "${var.nombre_proyecto}-app"
    Proyecto = var.nombre_proyecto
  }

  lifecycle {
    ignore_changes = [ami]
  }
}
