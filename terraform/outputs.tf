output "ip_publica" {
  value = aws_instance.app.public_ip
}

output "url_app" {
  value = "http://${aws_instance.app.public_ip}:${var.puerto_app}"
}

output "inventario" {
  value = <<-EOT
    [web]
    ${aws_instance.app.public_ip}

    [web:vars]
    ansible_user=ubuntu
    ansible_ssh_private_key_file=${var.ruta_clave_privada}
    puerto_app=${var.puerto_app}
  EOT
}
