data "aws_availability_zones" "disponibles" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.7.3"

  name = "${var.nombre_proyecto}-vpc"
  cidr = "10.0.0.0/16"

  azs            = [data.aws_availability_zones.disponibles.names[0]]
  public_subnets = ["10.0.101.0/24"]

  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true

  tags = {
    Proyecto = var.nombre_proyecto
  }
}

module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${var.nombre_proyecto}-sg"
  description = "Acceso SSH y al puerto de la aplicacion"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = var.cidr_ssh
    },
    {
      from_port   = var.puerto_app
      to_port     = var.puerto_app
      protocol    = "tcp"
      description = "Aplicacion de tareas"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_rules = ["all-all"]

  tags = {
    Proyecto = var.nombre_proyecto
  }
}
