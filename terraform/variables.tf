variable "aws_region" {
  type        = string
  description = "Región de AWS donde se crea la infraestructura"
  default     = "us-east-1"
}

variable "aws_access_key" {
  type        = string
  description = "Access key de AWS. Si no se define se usan las variables de entorno o el perfil configurado"
  default     = null
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "Secret key de AWS"
  default     = null
  sensitive   = true
}

variable "nombre_proyecto" {
  type        = string
  description = "Prefijo para nombrar los recursos"
  default     = "tareas"
}

variable "tipo_instancia" {
  type        = string
  description = "Tipo de instancia EC2"
  default     = "t3.micro"
}

variable "puerto_app" {
  type        = number
  description = "Puerto en el que escucha la aplicación"
  default     = 8000
}

variable "cidr_ssh" {
  type        = string
  description = "Rango de IPs que puede conectarse por SSH"
  default     = "0.0.0.0/0"
}

variable "ruta_clave_publica" {
  type        = string
  description = "Ruta de la clave pública SSH que se registra en AWS"
  default     = "~/.ssh/tareas-key.pub"
}

variable "ruta_clave_privada" {
  type        = string
  description = "Ruta de la clave privada SSH que usa Ansible"
  default     = "~/.ssh/tareas-key"
}
