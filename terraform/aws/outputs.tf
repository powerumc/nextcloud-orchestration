output "nextcloud_eip" {
  value = aws_eip.eip.public_ip
}

output "nextcloud_domain" {
  value = var.nextcloud.your_nextcloud_domain
}

output "nextcloud_email" {
  value = var.nextcloud.your_email
}

output "nextcloud_ssh_key_file_path" {
  value = var.nextcloud.ssh_key_file_path
}