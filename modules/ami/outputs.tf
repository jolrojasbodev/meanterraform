# modules/ami/outputs.tf

output "ean_ami_id" {
  value       = data.local_file.ean_ami_id.content
  description = "ID de la AMI del servidor web (Nginx/Node.js/Express)"
}

output "mongodb_ami_id" {
  value       = data.local_file.mongo_ami_id.content
  description = "ID de la AMI de MongoDB"
}