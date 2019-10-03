output "public_ip" {
  description = "Public IP for the web server"
  value = aws_instance.this.public_ip
}
